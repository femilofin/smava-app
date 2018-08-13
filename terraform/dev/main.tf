variable "environment" {}

module "vpc" {
  source      = "../modules/vpc"
  environment = "${var.environment}"
}

module "ecs" {
  source = "../modules/ecs"
  environment = "${var.environment}"
  cluster_name = "smava-${var.environment}"
}
