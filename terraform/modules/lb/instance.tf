data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-resolute-26.04-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "nginx" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "${var.instance_type}"

  iam_instance_profile = var.iam_instance_profile
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_web_traffic.id]
  subnet_id                   = var.subnet_id
  user_data_base64            = base64encode(templatefile("../modules/lb/user_data.sh", {
    backend_1 = var.backend_1
    backend_2 = var.backend_2
  }))

  tags = {
    Name = "${var.project_name}-nginx"
  }
}
