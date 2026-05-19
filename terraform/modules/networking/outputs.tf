output "vpc_id" {
  value = aws_vpc.main-vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public.id
}