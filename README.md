# CS1 – Terraform & Application Automation

This repository contains the Infrastructure as Code and application deployment automation for Case Study 1.

## Terraform

Terraform is used to deploy and manage the AWS infrastructure.

The infrastructure consists of:

* Hub and spoke VPCs connected through VPC peering
* Public subnets for the Application Load Balancer
* Private subnets for the web servers
* Private database subnets for MariaDB RDS
* Auto Scaling Group for the web servers
* VPC endpoints for AWS services
* Security groups controlling communication between components
* KMS encryption for the database

Terraform state is stored in an S3 backend.

## Application Deployment

Application deployment is automated through GitHub Actions.

When changes are pushed to `main` that affect `website/`, the workflow:

1. Checks that the web infrastructure is available.
2. Uploads the application to S3.
3. Starts an Auto Scaling instance refresh.
4. New instances retrieve the application from S3 during startup.
5. The Application Load Balancer checks the new instances.

This uses a **rolling deployment** so instances are replaced gradually.

## Terraform CI/CD

Terraform is also managed through GitHub Actions.

Pull requests run `terraform plan` to validate and preview infrastructure changes.

Changes pushed to `main` automatically run the Terraform plan and apply.

Terraform can also be manually applied or destroyed through the workflow.

The workflows run on a self-hosted GitHub Actions runner in the hub VPC.

## Monitoring

The web servers expose metrics through Node Exporter.

Prometheus runs in the hub VPC and discovers the web instances automatically. Grafana is used for monitoring and visualization.

Current alerts cover high CPU usage and unreachable web instances.

## Repository Structure

The Terraform configuration is split into files for networking, routing, security, compute, load balancing, database resources, variables, providers and outputs.

The application is located in `website/`.

## Technologies

AWS, Terraform, GitHub Actions, EC2, Auto Scaling, Application Load Balancer, S3, MariaDB RDS, Prometheus, Grafana and Node Exporter.
