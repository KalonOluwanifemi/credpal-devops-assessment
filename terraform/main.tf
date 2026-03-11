module "app_infra" {
  source = "./modules/app-infra"

  env           = var.env
  vpc_cidr      = var.vpc_cidr
  instance_type = var.instance_type
  app_port      = var.app_port
  docker_image  = var.docker_image
}
