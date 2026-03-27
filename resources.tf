# [REFACTOR #1]  자격증명 변수 호출 제거 (provider.tf Profile 방식으로 이관)
# [REFACTOR #2]  depends_on 명시 유지 (암묵적 의존성 + 명시적 안전장치)
# [REFACTOR #12] admin_cidr_blocks 전달

module "network" {
  source             = "./modules/network"
  availability_zones = var.availability_zones
  cidr_block         = var.cidr_block
}

module "securitygroup" {
  source            = "./modules/securitygroup"
  vpc_id            = module.network.vpc_id
  admin_cidr_blocks = var.admin_cidr_blocks

  depends_on = [module.network]
}

module "instance" {
  source        = "./modules/instance"
  instance_type = var.instance_type
  subnet_id     = module.network.public_subnets[0]
  sg_id         = module.securitygroup.ssh_sg_id

  depends_on = [
    module.network,
    module.securitygroup
  ]
}
