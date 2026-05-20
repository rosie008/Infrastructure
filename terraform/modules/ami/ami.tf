data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = [var.filter_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}