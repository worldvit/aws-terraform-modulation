variable "availability_zones" {
  description = "가용 영역 목록 (루트에서 주입)"
  type        = list(string)
}

variable "cidr_block" {
  description = "VPC CIDR 블록 (루트에서 주입)"
  type        = string
}

variable "public_subnets" {
  description = "퍼블릭 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "private_subnets" {
  description = "프라이빗 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.10.101.0/24", "10.10.102.0/24", "10.10.103.0/24"]
}
