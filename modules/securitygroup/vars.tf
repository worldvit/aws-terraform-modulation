variable "vpc_id" {
  description = "SG를 생성할 VPC ID"
  type        = string
}

variable "admin_cidr_blocks" {
  description = "SSH/RDP 접근 허용 CIDR 목록 (운영 환경은 반드시 특정 IP)"
  type        = list(string)
}
