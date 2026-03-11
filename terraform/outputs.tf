output "app_public_ip" {
  value       = module.app_infra.app_public_ip
  description = "Elastic IP of the EC2 app server"
}

output "alb_dns_name" {
  value       = module.app_infra.alb_dns_name
  description = "DNS name of the Application Load Balancer"
}
