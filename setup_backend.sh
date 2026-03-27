#!/bin/bash
# backend.tf 에서 사용하는 S3 버킷과 DynamoDB 테이블 사전 생성 스크립트

set -euo pipefail

# ── 설정값 (backend.tf 와 반드시 일치) ──────────────────────────────
BUCKET="terraform-state-dev-20260325"
TABLE="terraform-state-lock"
REGION="us-west-2"
PROFILE="default"

echo "======================================================"
echo " Terraform Remote Backend 사전 리소스 생성"
echo "  Profile : $PROFILE"
echo "  Region  : $REGION"
echo "  S3      : s3://$BUCKET"
echo "  DynamoDB: $TABLE"
echo "======================================================"

# ── 1. S3 버킷 생성 ────────────────────────────────────────────────
echo ""
echo "[1/4] S3 버킷 생성 중..."

if aws s3api head-bucket \
      --bucket "$BUCKET" \
      --region "$REGION" \
      --profile "$PROFILE" 2>/dev/null; then
  echo "  버킷이 이미 존재합니다: s3://$BUCKET"
else
  # us-east-1 은 LocationConstraint 없이 생성해야 함
  if [ "$REGION" = "us-west-2" ]; then
    aws s3api create-bucket \
      --bucket "$BUCKET" \
      --region "$REGION" \
      --profile "$PROFILE"
  else
    aws s3api create-bucket \
      --bucket "$BUCKET" \
      --region "$REGION" \
      --profile "$PROFILE" \
      --create-bucket-configuration LocationConstraint="$REGION"
  fi
  echo "  ✅ 버킷 생성 완료: s3://$BUCKET"
fi

# ── 2. S3 버킷 버전 관리 활성화 ────────────────────────────────────
echo ""
echo "[2/4] S3 버킷 버전 관리 활성화..."
aws s3api put-bucket-versioning \
  --bucket "$BUCKET" \
  --region "$REGION" \
  --profile "$PROFILE" \
  --versioning-configuration Status=Enabled
echo "  ✅ 버전 관리 활성화 완료"

# ── 3. S3 버킷 암호화 설정 ─────────────────────────────────────────
echo ""
echo "[3/4] S3 서버 사이드 암호화(SSE-S3) 설정..."
aws s3api put-bucket-encryption \
  --bucket "$BUCKET" \
  --region "$REGION" \
  --profile "$PROFILE" \
  --server-side-encryption-configuration '{
    "Rules": [{
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }]
  }'
echo "  ✅ 암호화 설정 완료"

# ── 4. DynamoDB 테이블 생성 ────────────────────────────────────────
echo ""
echo "[4/4] DynamoDB 테이블 생성 중..."

if aws dynamodb describe-table \
      --table-name "$TABLE" \
      --region "$REGION" \
      --profile "$PROFILE" 2>/dev/null | grep -q "TableStatus"; then
  echo "  ✅ 테이블이 이미 존재합니다: $TABLE"
else
  aws dynamodb create-table \
    --table-name "$TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST \
    --region "$REGION" \
    --profile "$PROFILE"

  echo "  ⏳ 테이블 활성화 대기 중..."
  aws dynamodb wait table-exists \
    --table-name "$TABLE" \
    --region "$REGION" \
    --profile "$PROFILE"
  echo "  ✅ DynamoDB 테이블 생성 완료: $TABLE"
fi

echo ""
echo "======================================================"
echo " 모든 백엔드 리소스 준비 완료!"
echo " 이제 terraform init 을 실행하세요."
echo "======================================================"
