variable "region" { description = "Region to deploy resources" }
variable "vpc_cidr" { description = "CIDR for creating VPC"  }
variable "public_subnets" { description = "Public Subnets for creating VPC"  }
variable "private_subnets" { description = "Private Subnets for creating VPC"  }
variable "domain_name" { description = "Domain for launching resources"  }
variable "ecs_image" {
   description = "ECR Image URI"
    }
variable "project_name" {
  description = "Name of the project"
  type        = string
}


# Define the variable for Hosted Zone ID
variable "hosted_zone_id" {
  description = "The ID of the Route 53 Hosted Zone"
  type        = string
}
