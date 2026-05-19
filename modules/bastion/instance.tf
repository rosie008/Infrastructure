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

resource "aws_key_pair" "key-pair" {
  key_name   = "rose-key"
  public_key = file("${var.key-pair}")
}

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "${var.instance_type}"

  key_name                    = aws_key_pair.key-pair.key_name  
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = var.subnet_id
  user_data_base64            = base64encode(file("../modules/bastion/user_data.sh"))

  tags = {
    Name = "${var.project_name}-bastion"
  }
}
