variable "aws_profile" {
  description = "AWS CLI Profile (~/.aws/credentials)"
  type        = string
  default     = "default"
}

variable "aws_region" {
  description = "AWS 배포 리전"
  type        = string
  default     = "us-west-2"
}

variable "availability_zones" {
  description = "사용할 가용 영역 목록"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
}

variable "cidr_block" {
  description = "VPC CIDR 블록"
  type        = string
  default     = "10.10.0.0/16"
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t2.micro"
}

# [REFACTOR #12] 보안 그룹 허용 IP 대역 — 환경별 tfvars로 분리
variable "admin_cidr_blocks" {
  description = "SSH/RDP 접근 허용 CIDR 목록 (운영 환경은 특정 IP로 제한)"
  type        = list(string)
  # SECURITY: 기본값은 제공하지 않음 → tfvars에서 반드시 명시
}
