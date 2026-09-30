output "alb_dns_name" {
  description = "DNS name of the public application load balancer"
  value       = aws_lb.web.dns_name
}

output "database_endpoint" {
  description = "Private endpoint of the MariaDB instance"
  value       = aws_db_instance.mariadb.endpoint
}

output "vpc_id" {
  description = "ID of the application VPC"
  value       = aws_vpc.spoke.id
}

output "vpc_peering_connection_id" {
  description = "ID of the VPC peering connection to VPC 2"
  value       = aws_vpc_peering_connection.spoke_to_hub.id
}
