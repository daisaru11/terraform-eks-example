variable shared_prefix {}

variable "cluster_name" {
  
}

variable "vpc_id" {
  
}

variable "public_subnet_ids" {
  type    = "list"
}

variable "private_subnet_ids" {
  type    = "list"
}

variable "node_instance_type" {
  default = "t3.large"
}


variable "node_ami_id" {
  default = "ami-0440e4f6b9713faf6" #us-east-1 amazon-eks-node-v24
  #default = "ami-0a54c984b9f908c81" #us-west-2 amazon-eks-node-v24
}

variable "self_ip" {
}
