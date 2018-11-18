resource "aws_security_group" "cluster" {
  name        = "${var.shared_prefix}-cluster"
  description = "EKS cluster control plane security group"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "cluster-egress-to-node" {
  security_group_id = "${aws_security_group.cluster.id}"
  type = "egress"
  description       = "Allow the cluster control plane to communicate with worker Kubelet and pods"
  from_port = 1025
  to_port = 65535
  protocol = "tcp"
  source_security_group_id = "${aws_security_group.node.id}"
}

resource "aws_security_group_rule" "cluster-ingress-from-node" {
  security_group_id = "${aws_security_group.cluster.id}"
  type              = "ingress"
  description       = "Allow pods to communicate with the cluster API Server"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.node.id}"
}

resource "aws_security_group_rule" "demo-cluster-ingress-workstation-https" {
  security_group_id = "${aws_security_group.cluster.id}"
  type              = "ingress"
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["${var.self_ip}/32"]
  protocol          = "tcp"
}