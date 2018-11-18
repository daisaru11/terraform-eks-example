resource "aws_vpc" "vpc" {
  cidr_block           = "${var.vpc_cidr_block}"
  instance_tenancy     = "default"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"

  tags = "${
    map(
      "Name", "${var.shared_prefix}-vpc",
      "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
    )
  }"
}

###
# public (DMZ) subnet
resource "aws_subnet" "public_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_public_a_cidrblock}"
  availability_zone       = "${var.availability_zone_a}"
  map_public_ip_on_launch = true

  tags = "${
    map(
      "Name", "${var.shared_prefix}-public-subnet-a",
      "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
    )
  }"
}

resource "aws_subnet" "public_c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_public_c_cidrblock}"
  availability_zone       = "${var.availability_zone_c}"
  map_public_ip_on_launch = true

  tags = "${
    map(
      "Name", "${var.shared_prefix}-public-subnet-c",
      "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
    )
  }"
}

resource "aws_route_table_association" "public_a" {
  route_table_id = "${aws_route_table.public_route.id}"
  subnet_id      = "${aws_subnet.public_a.id}"
}

resource "aws_route_table_association" "public_c" {
  route_table_id = "${aws_route_table.public_route.id}"
  subnet_id      = "${aws_subnet.public_c.id}"
}

###
# public (bastion) subnet
resource "aws_subnet" "bastion" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_bastion_cidrblock}"
  availability_zone       = "${var.availability_zone_c}"
  map_public_ip_on_launch = true

  tags {
    "Name" = "${var.shared_prefix}-bastion-subnet"
  }
}

resource "aws_route_table_association" "bastion" {
  route_table_id = "${aws_route_table.public_route.id}"
  subnet_id      = "${aws_subnet.bastion.id}"
}

###
# private subnet
resource "aws_subnet" "private_a" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_private_a_cidrblock}"
  availability_zone       = "${var.availability_zone_a}"
  map_public_ip_on_launch = false

  tags = "${
    map(
      "Name", "${var.shared_prefix}-private-subnet-a",
      "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
    )
  }"
}

resource "aws_subnet" "private_c" {
  vpc_id                  = "${aws_vpc.vpc.id}"
  cidr_block              = "${var.subnet_private_c_cidrblock}"
  availability_zone       = "${var.availability_zone_c}"
  map_public_ip_on_launch = false

  tags = "${
    map(
      "Name", "${var.shared_prefix}-private-subnet-c",
      "kubernetes.io/cluster/${var.eks_cluster_name}", "shared"
    )
  }"
}

resource "aws_route_table_association" "private_a" {
  route_table_id = "${aws_route_table.nat_a.id}"
  subnet_id      = "${aws_subnet.private_a.id}"
}

resource "aws_route_table_association" "private_c" {
  route_table_id = "${aws_route_table.nat_c.id}"
  subnet_id      = "${aws_subnet.private_c.id}"
}

###
# gateway
resource "aws_internet_gateway" "GW" {
  vpc_id = "${aws_vpc.vpc.id}"
}

resource "aws_route_table" "public_route" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.GW.id}"
  }

  tags {
    Name = "${var.shared_prefix}-public_route"
  }
}

###
# nat
resource "aws_route_table" "nat_a" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_a.id}"
  }

  tags {
    Name = "${var.shared_prefix}-nat-route-a"
  }
}

resource "aws_route_table" "nat_c" {
  vpc_id = "${aws_vpc.vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat_c.id}"
  }

  tags {
    Name = "${var.shared_prefix}-nat-route-c"
  }
}

resource "aws_eip" "nat_a" {
  vpc = true
}

resource "aws_eip" "nat_c" {
  vpc = true
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = "${aws_eip.nat_a.id}"
  subnet_id     = "${aws_subnet.public_a.id}"

  tags {
    Name = "${var.shared_prefix}-gw-nat-a"
  }
}

resource "aws_nat_gateway" "nat_c" {
  allocation_id = "${aws_eip.nat_c.id}"
  subnet_id     = "${aws_subnet.public_c.id}"

  tags {
    Name = "${var.shared_prefix}-gw-nat-c"
  }
}
