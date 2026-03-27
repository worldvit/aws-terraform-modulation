# [REFACTOR #9] 인스턴스 모듈 output 구현 — Ansible inventory 등 연동용

output "public_ips" {
  description = "인스턴스 이름 → 공인 IP 맵"
  value       = { for k, v in aws_instance.kubernetes : k => v.public_ip }
}

output "private_ips" {
  description = "인스턴스 이름 → 사설 IP 맵"
  value       = { for k, v in aws_instance.kubernetes : k => v.private_ip }
}

output "instance_ids" {
  description = "인스턴스 이름 → Instance ID 맵"
  value       = { for k, v in aws_instance.kubernetes : k => v.id }
}

output "subnet_id" {
  description = "인스턴스 배치 서브넷 ID"
  value       = var.subnet_id
}
