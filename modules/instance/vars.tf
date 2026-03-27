variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
}

variable "subnet_id" {
  description = "EC2를 배치할 서브넷 ID"
  type        = string
}

variable "sg_id" {
  description = "EC2에 연결할 보안 그룹 ID"
  type        = string
}

variable "path_to_public_key" {
  description = "SSH 공개키 경로 (루트 모듈 기준)"
  type        = string
  default     = "keys/mykey.pub"
}

variable "ec2_names" {
  description = "생성할 EC2 인스턴스 이름 목록 (for_each 키)"
  type        = list(string)
  default     = ["k8s-cp", "k8s-n1", "k8s-n2"]
}
