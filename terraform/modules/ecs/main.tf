resource "aws_ecs_cluster" "cluster" {
  name = "smava-${var.environment}"
}

# Creates ECS cluster and SG's
module "autoscaling" {
  source = "../autoscaling"
  environment = "${var.environment}"
  cluster_name = "${var.cluster_name}"
}
