############################
# OUTPUTS
############################

output "app_instance_id" {
  value       = aws_instance.app.id
  description = "EC2 instance ID for SSM access"
}

output "alb_dns_name" {
  value       = aws_lb.app.dns_name
  description = "DNS name of the Application Load Balancer"
}
