locals {
  name = "${var.project}-${var.environment}"
}

module "network" {
  source             = "../../modules/network"
  name               = local.name
  vpc_cidr           = var.vpc_cidr
  az_count           = 2
  single_nat_gateway = var.single_nat_gateway
}

module "security" {
  source            = "../../modules/security"
  name              = local.name
  vpc_id            = module.network.vpc_id
  alb_ingress_cidrs = var.alb_ingress_cidrs
}

module "alb" {
  source            = "../../modules/alb"
  name              = local.name
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  certificate_arn   = var.alb_certificate_arn
}

module "database" {
  source              = "../../modules/database"
  name                = local.name
  data_subnet_ids     = module.network.data_subnet_ids
  db_sg_id            = module.security.db_sg_id
  instance_class      = var.db_instance_class
  multi_az            = true
  deletion_protection = var.db_deletion_protection
  skip_final_snapshot = !var.db_deletion_protection
}

module "compute" {
  source                  = "../../modules/compute"
  name                    = local.name
  instance_type           = var.instance_type
  app_sg_id               = module.security.app_sg_id
  app_subnet_ids          = module.network.app_subnet_ids
  target_group_arn        = module.alb.target_group_arn
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  alb_arn_suffix          = module.alb.alb_arn_suffix
  db_secret_arn           = module.database.db_secret_arn
  db_host                 = module.database.db_address
  db_name                 = module.database.db_name
  min_size                = var.asg_min
  max_size                = var.asg_max
  desired_capacity        = var.asg_desired
  sns_topic_arn           = module.monitoring.sns_topic_arn
}

module "edge" {
  source       = "../../modules/edge"
  name         = local.name
  alb_dns_name = module.alb.alb_dns_name
  alb_https    = var.alb_certificate_arn != ""
}

module "dns" {
  count        = var.domain_name == "" ? 0 : 1
  source       = "../../modules/dns"
  name         = local.name
  domain_name  = var.domain_name
  record_name  = var.record_name
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id  = module.alb.alb_zone_id
  alb_https    = var.alb_certificate_arn != ""
}

module "monitoring" {
  source                  = "../../modules/monitoring"
  name                    = local.name
  alert_email             = var.alert_email
  alb_arn_suffix          = module.alb.alb_arn_suffix
  target_group_arn_suffix = module.alb.target_group_arn_suffix
  asg_name                = module.compute.asg_name
  db_instance_id          = module.database.db_instance_id
  web_acl_name            = module.alb.web_acl_name
}
