env           = "staging"
aws_region    = "eu-north-1"
vpc_cidr      = "10.0.0.0/16"
instance_type = "t3.micro"

docker_image  = "dockerhubuser/credpal-app-staging:latest"

app_port      = 3000
domain_name   = "staging.example.com"
