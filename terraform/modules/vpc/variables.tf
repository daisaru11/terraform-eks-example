variable shared_prefix {}

variable region {
  default = "us-east-1"
}

variable availability_zone_a {
  default = "us-east-1a"
}

variable availability_zone_c {
  default = "us-east-1c"
}

variable vpc_cidr_block {
  default = "10.0.0.0/16"
}

variable subnet_public_a_cidrblock {
  default = "10.0.1.0/24"
}

variable subnet_public_c_cidrblock {
  default = "10.0.2.0/24"
}

variable subnet_private_a_cidrblock {
  default = "10.0.3.0/24"
}

variable subnet_private_c_cidrblock {
  default = "10.0.4.0/24"
}

variable subnet_bastion_cidrblock {
  default = "10.0.5.0/24"
}


variable "eks_cluster_name" {
  
}
