variable "vpc_id" {
  description = "SG를 생성할 VPC ID"
  type        = string
}

# [REFACTOR #12] 보안 그룹 허용 CIDR — 루트에서 환경별로 주입
variable "admin_cidr_blocks" {
  description = "SSH/RDP 접근 허용 CIDR 목록 (운영 환경은 반드시 특정 IP)"
  type        = list(string)
}
