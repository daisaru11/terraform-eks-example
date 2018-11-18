module "vpc" {
  source        = "./modules/vpc"
  shared_prefix = "eks-demo"

  region = "us-east-1"
  availability_zone_a = "us-east-1a"
  availability_zone_c = "us-east-1c"

  eks_cluster_name ="eks-demo-cluster"
}
