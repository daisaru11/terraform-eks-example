module "eks" {
  source        = "./modules/eks"
  shared_prefix = "k8s-spn"
  cluster_name ="k8s-spn-cluster"

  vpc_id = "${module.vpc.vpc_id}"
  private_subnet_ids = ["${module.vpc.private_subnet_a_id}", "${module.vpc.private_subnet_c_id}"]
  public_subnet_ids = ["${module.vpc.public_subnet_a_id}", "${module.vpc.public_subnet_c_id}"]
  self_ip = "${var.self_ip}"
}
