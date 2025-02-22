# Deploying a Containerized Threat Modeling Application on Amazon ECS and AWS Fargate with Terraform

![Alt text](/architecture.jpeg)

This project demonstrates how to deploy a containerized Threat Modeling Application using Amazon Elastic Container Service (ECS) and AWS Fargate, orchestrated with Terraform. The architecture is designed for security, scalability, and high availability.

## Architecture Overview

The deployment utilizes a two-tier architecture comprising:

- **Public Subnets**: Hosting infrastructure components such as the Application Load Balancer (ALB) and NAT Gateway.
- **Private Subnets**: Hosting ECS tasks running the Threat Modeling Application, ensuring that application components are not directly exposed to the internet.

Key components include:

- **Virtual Private Cloud (VPC)**: Configured with public and private subnets across two Availability Zones for redundancy.
- **Internet Gateway**: Enables internet connectivity for resources in public subnets.
- **NAT Gateway**: Allows ECS tasks in private subnets to access the internet securely.
- **Security Groups**: Act as virtual firewalls to control inbound and outbound traffic for resources.
- **Application Load Balancer (ALB)**: Distributes incoming traffic evenly across ECS tasks.
- **AWS Certificate Manager (ACM)**: Manages SSL/TLS certificates for secure communications.
- **Amazon Route 53**: Manages DNS records and domain registration.

## Prerequisites

Before deploying the application, ensure you have the following:

- **AWS Account**: Active account with necessary permissions.
- **Terraform**: Installed on your local machine.
- **Docker**: Installed for building container images.
- **Domain Name**: Registered domain to associate with the application.

## Deployment Steps

1. **Clone the Repository**:

   ```bash
   git clone [https://github.com/your-username/your-repo-name.git](https://github.com/MurradA/aws-threat-model-app.git)
   cd aws-threat-model-app
   
2. **Prepare the Docker Image:**
- Navigate to your application directory containing the source code.
- Copy the Dockerfile from the cloned repository to your application directory.

3. **Build the Docker image:**
- Build the image using the following command
docker build -t your-repo-name/threat-model-app path/to/your/application/
- Tag and push the image to your Amazon Elastic Container Registry (ECR):

   ```bash
  aws ecr create-repository --repository-name threat-model-app

   docker tag your-repo-name/threat-model-app:latest aws_account_id.dkr.ecr.your-aws-region.amazonaws.com/threat-model-app:latest

  aws ecr get-login-password --region your-aws-region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.your-aws-region.amazonaws.com

  docker push aws_account_id.dkr.ecr.your-aws-region.amazonaws.com/threat-model-app:latest

4. **Configure Terraform Variables:**
Edit the terraform.tfvars file in the cloned repository to include your specific configurations:

   ```bash
   project_name     = "your-project-name"
   region           = "your-aws-region"
   vpc_cidr         = "your-vpc-cidr-block"
   public_subnets   = ["your-public-subnet-1-cidr", "your-public-subnet-2-cidr"]
   private_subnets  = ["your-private-subnet-1-cidr", "your-private-subnet-2-cidr"]
   domain_name      = "your-domain-name"
   ecs_image        = "aws_account_id.dkr.ecr.your-aws-region.amazonaws.com/threat-model-app:latest"
   hosted_zone_id   = "your-hosted-zone-id"

Replace the placeholder values with your specific configurations:

- **your-project-name:** A unique name for your project.
- **your-aws-region:** The AWS region where you want to deploy the resources (e.g., us-east-1).
- **your-vpc-cidr-block:** The CIDR block for your VPC (e.g., 10.0.0.0/16).
- **your-public-subnet-1-cidr and your-public-subnet-2-cidr:** CIDR blocks for your public subnets (e.g., 10.0.1.0/24, 10.0.2.0/24).
- **your-private-subnet-1-cidr and your-private-subnet-2-cidr:** CIDR blocks for your private subnets (e.g., 10.0.3.0/24, 10.0.4.0/24).
- **your-domain-name:** Your registered domain name.
- **aws_account_id:** Your AWS account ID.
- **your-hosted-zone-id:** The ID of your Route 53 hosted zone.

5. **Initialize and Deploy with Terraform:**
- Navigate to the Terraform configuration directory:
  
   ```bash
  cd path/to/your-repo-name/terraform/
   
- Initialize Terraform:

   ```bash
   terraform init

- Review the execution plan:

  ```bash
  terraform plan

- Apply the Terraform configuration to deploy resources:

  ```bash
  terraform apply

- Confirm the deployment when prompted.

6. **Access the Application:**
- Once deployment is complete, retrieve the ALB DNS name from the Terraform output or the AWS Management Console.
- Update your domain's DNS settings in Route 53 to point to the ALB.
- Access the application via your domain name over HTTPS.

7. Security Considerations
- **Private Subnets:** ECS tasks are deployed in private subnets to prevent direct internet exposure.
- **NAT Gateway:** Allows outbound internet access for tasks without exposing them to inbound traffic.
- **SSL/TLS Encryption: **Managed by AWS Certificate Manager to secure data in transit.
- **Security Groups:** Configured to allow only necessary traffic to and from resources.

**Cleanup**
To remove the deployed resources and avoid incurring charges:

    terraform plan

Confirm the destruction when prompted.

## References

- [AWS Threat Composer Tool](https://aws.amazon.com/threat-composer/)
- [Terraform AWS Provider Documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Docker Official Documentation](https://docs.docker.com/)
- [Amazon ECS Documentation](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/Welcome.html)
