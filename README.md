# Case Study 1 infrastructure

This root module creates VPC 1 with public ALB subnets, private web subnets, and private database subnets. It also creates a VPC peering connection to the existing hub VPC 2.

## Traffic flow

- Internet traffic enters the public ALB through the Internet Gateway.
- The ALB forwards HTTP traffic to the web Auto Scaling Group in private subnets.
- Web servers connect to MariaDB in the DB subnets on port 3306.
- VPC 1 private and database subnets route `10.1.0.0/16` through the peering connection.
- No NAT Gateway or NAT instance is configured.

Before applying, copy `terraform.tfvars.example` to `terraform.tfvars` and provide the existing VPC 2 ID and the pre-baked web AMI ID.
