env           = "production"
aws_region    = "eu-north-1"
vpc_cidr      = "10.1.0.0/16"
instance_type = "t3.small"

docker_image  = "dockerhubuser/credpal-app-prod:latest"

app_port      = 3000
domain_name   = "example.com"
