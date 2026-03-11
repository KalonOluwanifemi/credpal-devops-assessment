module "app_infra" {
  source = "./modules/app-infra"

  env           = var.env
  aws_region    = var.aws_region
  vpc_cidr      = var.vpc_cidr
  instance_type = var.instance_type
  docker_image  = var.docker_image
  app_port      = var.app_port
  domain_name   = var.domain_name
}
