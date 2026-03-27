#!/bin/bash
# [REFACTOR #13] Kubernetes 노드 초기화 UserData 템플릿
# templatefile() 변수: node_name, node_role

set -euo pipefail
NODE_NAME="${node_name}"
NODE_ROLE="${node_role}"

echo "=== Initializing $NODE_NAME ($NODE_ROLE) ==="

# 시스템 업데이트
apt-get update -y
apt-get upgrade -y

# 필수 패키지 설치
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 호스트네임 설정
hostnamectl set-hostname $NODE_NAME

# swap 비활성화 (Kubernetes 필수)
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

# 커널 모듈 로드
cat <<KMOD | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
KMOD
modprobe overlay && modprobe br_netfilter

# sysctl 설정
cat <<SYSCTL | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
SYSCTL
sysctl --system

# containerd 설치
apt-get install -y containerd
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd && systemctl enable containerd

# kubeadm / kubelet / kubectl 설치 (v1.29)
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key \
  | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' \
  | tee /etc/apt/sources.list.d/kubernetes.list
apt-get update -y
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# Control Plane 전용: kubeadm init 및 CNI 설치
if [ "$NODE_ROLE" = "control-plane" ]; then
  kubeadm init --pod-network-cidr=192.168.0.0/16
  mkdir -p /home/ubuntu/.kube
  cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
  chown ubuntu:ubuntu /home/ubuntu/.kube/config
  # Calico CNI 설치
  kubectl --kubeconfig=/home/ubuntu/.kube/config apply \
    -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml
fi

echo "=== $NODE_NAME initialization complete ==="
