variable "region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "eu-central-1"
}

variable "vpc_name" {
  description = "Name used as the prefix for VPC resources"
  type        = string
  default     = "spoke-prod-1"
}

variable "hub_vpc_id" {
  description = "ID of the existing VPC 2 used as the peering target"
  type        = string
}

variable "hub_vpc_cidr" {
  description = "CIDR block of the existing VPC 2 used as the peering target"
  type        = string
  default     = "10.1.0.0/28"
}

variable "hub_route_priv-table_id" {
  description = "Route table ID of the private route table in VPC 2"
  type        = string
  default     = " rtb-09307dea035fe3f92"
}


variable "auto_accept_peering" {
  description = "Whether this account can automatically accept the VPC peering request"
  type        = bool
  default     = true
}

variable "web_ami_id" {
  description = "Pre-baked AMI ID for the private web servers"
  type        = string
}

variable "web_instance_type" {
  description = "EC2 instance type for the web Auto Scaling Group"
  type        = string
  default     = "t4g.micro"
}

variable "db_engine_version" {
  description = "MariaDB engine version available in the selected AWS region"
  type        = string
  default     = "12.3.3"
}

variable "db_username" {
  description = "MariaDB master username"
  type        = string
  default     = "admin"
}

variable "db_name" {
  description = "Initial MariaDB database name"
  type        = string
  default     = "ticketdb"
}

variable "db_password" {
  description = "MariaDB master password"
  type        = string
  sensitive   = true
  default     = "ChickenStock2026~!#$"
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot when the database is destroyed"
  type        = bool
  default     = true
}