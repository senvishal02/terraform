resource "aws_subnet" "public_subnets" {
  count                   = length(var.public_subnets)
  vpc_id                  = aws_vpc.eks_vpc.id
  cidr_block              = element(var.public_subnets, count.index)
  availability_zone       = element(var.public_az, count.index)
  map_public_ip_on_launch = true

  tags = {
    "Name" = "${var.environment}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.eks_vpc.id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.public_az, count.index)

  tags = {
    "Name" = "${var.environment}-private-subnet-${count.index}"
  }
}