############################
# OUTPUTS
############################

output "app_public_ip" {
  value       = aws_eip.app.public_ip
  description = "Elastic IP of the EC2 app server"
}

output "alb_dns_name" {
  value       = aws_lb.app.dns_name
  description = "DNS name of the Application Load Balancer"
}
