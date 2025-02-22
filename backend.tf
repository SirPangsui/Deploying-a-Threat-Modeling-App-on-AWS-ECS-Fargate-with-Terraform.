terraform {
  backend "s3" {
    bucket         = "bryan-project-terraform-state"
    key            = "threat-module/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock-threat"
  }
}
