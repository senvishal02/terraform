resource "aws_internet_gateway" "igw" {
  count  = var.create_internet_gateway ? 1 : 0
  vpc_id = aws_vpc.eks_vpc.id

  tags = {
    Name = "${var.environment}-igw"
  }
}