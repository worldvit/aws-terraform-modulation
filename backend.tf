# [REFACTOR #10] S3 + DynamoDB 원격 상태 관리
# 사전 준비:
#   aws s3 mb s3://my-tfstate-bucket --region us-west-2
#   aws dynamodb create-table \
#     --table-name terraform-state-lock \
#     --attribute-definitions AttributeName=LockID,AttributeType=S \
#     --key-schema AttributeName=LockID,KeyType=HASH \
#     --billing-mode PAY_PER_REQUEST

terraform {
  backend "s3" {
    bucket         = "terraform-state-dev-20260325"
    key            = "aws-terraform/terraform.tfstate"
    region         = "us-west-2"
    profile        = "default"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}
