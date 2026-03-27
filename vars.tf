# [REFACTOR #1]  AWS_ACCESS_KEY / AWS_SECRET_KEY 제거 → Profile 방식
# [REFACTOR #8]  미사용 변수(AMIS, PATH_TO_PRIVATE_KEY, INSTANCE_USERNAME) 제거
# [REFACTOR #12] admin_cidr_blocks 추가 → 보안 그룹 CIDR 변수화
# [REFACTOR #11] aws_profile / aws_region 으로 환경별 분리 지원

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
