output "vpc_id" {
  description = "생성된 VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "퍼블릭 서브넷 ID 목록"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "프라이빗 서브넷 ID 목록"
  value       = module.vpc.private_subnets
}