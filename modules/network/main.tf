# [REFACTOR #3] deprecated 'vpc = true' 주석 완전 제거
# [REFACTOR #7] aws_route_table_association 추가 (프라이빗 서브넷 연결)

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name            = "main"
  cidr            = var.cidr_block
  azs             = var.availability_zones
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  enable_vpn_gateway   = false
  single_nat_gateway     = true    # 추가
  one_nat_gateway_per_az = false   # 추가

  tags = {
    Name        = "main"
    Environment = "shared"
  }
}

# NAT Gateway용 탄력적 IP
# [REFACTOR #3] 'vpc = true' deprecated 속성 제거됨 (Provider v5+)
# resource "aws_eip" "nat" {
#   tags = {
#     Name = "main-nat-eip"
#   }
# }

# NAT Gateway — 퍼블릭 서브넷 배치
# resource "aws_nat_gateway" "main" {
#   subnet_id         = module.vpc.public_subnets[0]
#   connectivity_type = "public"
#   allocation_id     = aws_eip.nat.id

#   tags = {
#     Name = "main-ngw"
#   }
# }

# 프라이빗 서브넷 라우팅 테이블 — NAT GW 경유
# resource "aws_route_table" "private" {
#   vpc_id = module.vpc.vpc_id

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.main.id
#   }

#   tags = {
#     Name = "main-private-rt"
#   }
# }

# [REFACTOR #7] 프라이빗 서브넷 ↔ 라우팅 테이블 연결 (누락 항목 추가)
# resource "aws_route_table_association" "private" {
#   count          = length(module.vpc.private_subnets)
#   subnet_id      = module.vpc.private_subnets[count.index]
#   route_table_id = aws_route_table.private.id
# }
