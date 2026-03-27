# [REFACTOR #14] 루트 output 완성 — Ansible 등 downstream 파이프라인 연동

output "vpc_id" {
  description = "생성된 VPC ID"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "퍼블릭 서브넷 ID 목록"
  value       = module.network.public_subnets
}

output "private_subnets" {
  description = "프라이빗 서브넷 ID 목록"
  value       = module.network.private_subnets
}

output "instance_public_ips" {
  description = "EC2 인스턴스 이름 → 공인 IP 맵"
  value       = module.instance.public_ips
}

output "instance_private_ips" {
  description = "EC2 인스턴스 이름 → 사설 IP 맵"
  value       = module.instance.private_ips
}

output "instance_ids" {
  description = "EC2 인스턴스 이름 → Instance ID 맵"
  value       = module.instance.instance_ids
}

output "ssh_security_group_id" {
  description = "SSH 보안 그룹 ID"
  value       = module.securitygroup.ssh_sg_id
}
