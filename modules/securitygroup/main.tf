# [REFACTOR #12] admin_cidr_blocks 변수화 → 0.0.0.0/0 전체 허용 제거

resource "aws_security_group" "ssh" {
  name        = "allow-ssh"
  description = "SSH access from admin CIDR only"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH from admin CIDR"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.admin_cidr_blocks   # [REFACTOR #12] 특정 IP만 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-ssh"
  }
}

resource "aws_security_group" "rdp" {
  name        = "allow-rdp"
  description = "RDP access from admin CIDR only"
  vpc_id      = var.vpc_id

  ingress {
    description = "RDP from admin CIDR"
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = var.admin_cidr_blocks   # [REFACTOR #12] 특정 IP만 허용
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-rdp"
  }
}
