project_name     = "your-project-name"
region           = "your-aws-region"
vpc_cidr         = "your-vpc-cidr-block"
public_subnets   = ["your-public-subnet-1-cidr", "your-public-subnet-2-cidr"]
private_subnets  = ["your-private-subnet-1-cidr", "your-private-subnet-2-cidr"]
domain_name      = "your-domain-name"
ecs_image        = "aws_account_id.dkr.ecr.your-aws-region.amazonaws.com/threat-model-app:latest"
hosted_zone_id   = "your-hosted-zone-id"
