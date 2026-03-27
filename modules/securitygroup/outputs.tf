output "ssh_sg_id" {
  description = "SSH 보안 그룹 ID"
  value       = aws_security_group.ssh.id
}

output "rdp_sg_id" {
  description = "RDP 보안 그룹 ID"
  value       = aws_security_group.rdp.id
}
