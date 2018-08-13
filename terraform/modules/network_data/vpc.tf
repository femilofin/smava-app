data "aws_vpc" "by_environment" {
  tags = {
    "Name" = "${var.environment}-vpc"
    "Terraform" = "true"
    "Environment" = "${var.environment}"
  }
}

output "vpc_id" {
  value =  "${data.aws_vpc.by_environment.id}"
}
