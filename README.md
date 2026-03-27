# aws-terraform — Kubernetes 클러스터 IaC

## 프로젝트 구조

```
aws-terraform/
├── provider.tf          # AWS Provider (Profile 인증)
├── backend.tf           # S3 + DynamoDB 원격 상태 관리
├── vars.tf              # 루트 변수 선언
├── resources.tf         # 모듈 호출 (루트 main 역할)
├── outputs.tf           # 루트 output
├── terraform.tfvars     # 기본 변수값 (gitignore 대상)
├── terraform.tfvars.dev # 개발 환경
├── terraform.tfvars.prod# 운영 환경
├── keys/                # SSH 키 저장 (gitignore 대상)
├── modules/
│   ├── network/         # VPC, Subnet, NAT GW, Route Table
│   ├── securitygroup/   # SSH/RDP 보안 그룹
│   └── instance/        # EC2 (Ubuntu 20.04, for_each)
└── scripts/
    └── k8s_init.sh.tpl  # Kubernetes 노드 초기화 UserData 템플릿
```

## 사전 준비

### 1. AWS Profile 설정
```bash
aws configure --profile default
```

### 2. S3 버킷 및 DynamoDB 테이블 생성 (원격 상태)
```bash
aws s3 mb s3://my-tfstate-bucket --region us-west-2
aws dynamodb create-table \
  --table-name terraform-state-lock \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-west-2
```

### 3. SSH 키 생성
```bash
ssh-keygen -t rsa -b 4096 -f keys/mykey -N ""
```

### 4. 관리자 IP 확인 및 설정
```bash
curl https://checkip.amazonaws.com
# 출력된 IP를 terraform.tfvars 의 admin_cidr_blocks 에 입력
```

## 실행 방법

```bash
# 초기화
terraform init

# 개발 환경
terraform plan  -var-file=terraform.tfvars.dev
terraform apply -var-file=terraform.tfvars.dev

# 운영 환경
terraform plan  -var-file=terraform.tfvars.prod
terraform apply -var-file=terraform.tfvars.prod

# output 확인
terraform output instance_public_ips

# Ansible inventory 자동 생성
terraform output -json instance_public_ips \
  | jq -r 'to_entries[] | "\(.key) ansible_host=\(.value) ansible_user=ubuntu"'
```

## 보안 주의사항

- `terraform.tfvars` 는 .gitignore 처리됨 → Git에 절대 커밋 금지
- `keys/` 디렉터리는 .gitignore 처리됨 → SSH 키 절대 커밋 금지
- `admin_cidr_blocks` 는 본인 관리자 IP/32 로 반드시 제한
