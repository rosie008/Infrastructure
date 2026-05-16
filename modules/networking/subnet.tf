#public subnet
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, 1)

  tags = {
    Name = "${var.project_name}-public-subnet"
  }
}


#private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.main-vpc.id
  cidr_block = cidrsubnet(aws_vpc.main-vpc.cidr_block, 8, 2)

  tags = {
    Name = "${var.project_name}-private-subnet"
  }
}
