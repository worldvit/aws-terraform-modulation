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
