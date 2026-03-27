# [REFACTOR #6]  미참조 data 블록 제거 (amazon-linux, ubuntu-1804)
# [REFACTOR #4c] resource 이름 충돌 해소 → for_each 단일 블록으로 통일
# [REFACTOR #13] user_data — templatefile()로 k8s_init.sh.tpl 연결

# Ubuntu 24.04 LTS — 최신 AMI 동적 조회
data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"]   # Canonical 공식 AWS 계정 ID

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "state"
    values = ["available"]          # 사용 가능한 상태의 AMI만 선택
  }
}

# SSH 키페어 — 루트 기준 경로에서 공개키 읽기
resource "aws_key_pair" "mykey" {
  key_name   = "mykey"
  public_key = file(var.path_to_public_key)
}

# [REFACTOR #4c] for_each 단일 블록 — count 버전 제거
# [REFACTOR #13] user_data: templatefile()로 노드별 초기화 스크립트 주입
resource "aws_instance" "kubernetes" {
  for_each = toset(var.ec2_names)

  ami                         = data.aws_ami.ubuntu_2404.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.mykey.key_name

  # [REFACTOR #13] 노드별 역할(cp/worker)을 스크립트 변수로 전달
  user_data = templatefile("${path.root}/scripts/k8s_init.sh.tpl", {
    node_name = each.key
    node_role = each.key == "k8s-cp" ? "control-plane" : "worker"
  })

  tags = {
    Name = each.key
    Role = each.key == "k8s-cp" ? "control-plane" : "worker"
  }
}
