resource "aws_key_pair" "ecs" {
  key_name   = "${var.environment}"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDv0Zn1t/Rpqtc3DhXrP3d1c1i4d8YKBSb+FGvu10LUgFv/dooPPdKFhi7r2jfjxW4TwDEBNmZNy1BFhfubVyHjmJpTnnb84OJUAbGKWDoL3WS/dxDlzGFf3u9W08FlEmWmqT0Q0WXuXj+317CnWkXcNE5k2qMABP7FJoWLacTHFo3Qt4V875Wm+88JonI6yXnVdeDoRW8gPRV25b0FMitIF9M4ORve7uq+dCo6L/UspMnVwjV2R1vCoGHz7c8V1PwJ/cWMdAMHEdO3HARBogZo/gfotR6uzaDUTDrZR7QJQ6YPSB30Id2Vtz5D1ugeSVdOXHvVfuip3WDpN7GtwGS5 oluwafemi.olofintuyi@gmail.com"
}

module "vpc" {
  source      = "../modules/vpc"
  environment = "${var.environment}"
}

module "bastion" {
  source         = "../modules/bastion"
  environment    = "${var.environment}"
  vpc_id         = "${module.vpc.vpc_id}"
  public_subnets = "${module.vpc.public_subnets}"
}

module "ecs" {
  source          = "../modules/ecs"
  environment     = "${var.environment}"
  cluster_name    = "${var.cluster_name}"
  vpc_id          = "${module.vpc.vpc_id}"
  bastion_sg_id   = "${module.bastion.bastion_sg_id}"
  private_subnets = "${module.vpc.private_subnets}"
  public_subnets  = "${module.vpc.public_subnets}"
}

module "ecs-service" {
  source             = "../modules/ecs-service"
  project            = "${var.project}"
  app                = "${var.app}"
  environment        = "${var.environment}"
  health_check       = "${var.health_check}"
  http_rule_priority = "${var.http_rule_priority}"
  domain             = "${var.domain}"
  url                = "${var.url}"
  alb_dns_name       = "${module.ecs.alb_dns_name}"
  alb_zone_id        = "${module.ecs.alb_zone_id}"
  http_listener_arn  = "${module.ecs.http_listener_arn}"
  application_memory = "${var.application_memory}"
  vpc_id             = "${module.vpc.vpc_id}"
  cluster_name       = "${var.cluster_name}"
  ecs_iam_role       = "${module.ecs.ecs_iam_role}"
}
