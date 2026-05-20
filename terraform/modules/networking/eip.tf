resource "aws_eip" "nat_eip" {
  domain   = "vpc"

   tags = {
    Name = "${var.project_name}-nat-eip"
  }
}