env           = "staging"
aws_region    = "us-east-1"
vpc_cidr      = "10.0.0.0/16"
instance_type = "t2.micro"
docker_image  = "placeholder"  # overridden at deploy time by pipeline
app_port      = 3000
domain_name   = "staging.yourdomain.com"
