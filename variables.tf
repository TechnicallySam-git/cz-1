variable "region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "eu-central-1"
}
##################################################################################################################
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
  default     = "10.1.0.0/16"
}

variable "hub_route_pub_table_cidr" {
  description = "Route table CIDR of the public route table in VPC 2"
  type        = string
  default     = "10.1.0.0/28"
}

variable "hub_route_priv_table_cidr" {
  description = "Route table CIDR of the private route table in VPC 2"
  type        = string
  default     = "10.1.1.0/28"
}


variable "hub_route_priv_table_id" {
  description = "Route table ID of the private route table in VPC 2"
  type        = string
}
##################################################################################################################
variable "spoke-vpc-cidr" {
  description = "CIDR block of the VPC 1"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke-route-pub-1-table-cidr" {
  description = "Route table ID of the public route table in VPC 1"
  type        = string
  default     = "10.0.10.0/28"
}

variable "spoke-route-pub-2-table-cidr" {
  description = "Route table ID of the public route table in VPC 1"
  type        = string
  default     = "10.0.11.0/28"
}



variable "spoke-route-priv-1-table-cidr" {
  description = "Route table ID of the private route table in VPC 1"
  type        = string
  default     = "10.0.1.0/28"
}

variable "spoke-route-priv-2-table-cidr" {
  description = "Route table ID of the private route table in VPC 1"
  type        = string
  default     = "10.0.2.0/28"
}
#############################################################
variable "spoke-route-db-table-cidr" {
  description = "Route table ID of the database route table in VPC 1"
  type        = string
  default     = "10.0.20.0/28"
}

variable "spoke-route-db-2-table-cidr" {
  description = "Route table ID of the database route table in VPC 1"
  type        = string
  default     = "10.0.21.0/28"
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
}

variable "skip_final_snapshot" {
  description = "Skip the final snapshot when the database is destroyed"
  type        = bool
  default     = true
}

variable "domain_name" {
  type    = string
  default = "holidayparks.live"
}