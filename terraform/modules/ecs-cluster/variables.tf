variable "environment" {}
variable "cluster_name" {}
variable "vpc_id" {}
variable "bastion_sg_id" {}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}
