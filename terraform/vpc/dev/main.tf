variable "environment" {}

module "vpc" {
  source      = "../"
  environment = "${var.environment}"
}
