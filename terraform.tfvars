aws_profile        = "default"
aws_region         = "us-west-2"
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
cidr_block         = "10.10.0.0/16"
instance_type      = "t3.micro"

# [REFACTOR #12] SECURITY: 본인 관리자 IP로 반드시 변경 (curl https://checkip.amazonaws.com)
admin_cidr_blocks  = ["118.131.22.84/32"]
