
resource "aws_security_group" "node" {
  name        = "${var.shared_prefix}-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = "${var.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "node-ingress-from-node" {
  security_group_id = "${aws_security_group.node.id}"
  type              = "ingress"
  description       = "Allow node to communicate with each other"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  source_security_group_id = "${aws_security_group.node.id}"
}

resource "aws_security_group_rule" "node-ingress-from-control-plane" {
  security_group_id = "${aws_security_group.node.id}"
  type              = "ingress"
  description       = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port         = 1025
  to_port           = 65535
  protocol          = "tcp"
  source_security_group_id = "${aws_security_group.cluster.id}"
}