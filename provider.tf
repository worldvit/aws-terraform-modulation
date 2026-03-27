# [REFACTOR #1] 하드코딩 자격증명 제거 → AWS Profile 방식
# ~/.aws/credentials 및 ~/.aws/config 파일을 사용합니다.
# aws configure --profile <profile_name> 으로 설정하세요.

terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
}
