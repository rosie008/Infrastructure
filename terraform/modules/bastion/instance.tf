resource "aws_key_pair" "key-pair" {
  key_name   = "rose-key"
  public_key = file("${var.key-pair}")
}



resource "aws_instance" "bastion" {
  ami           = var.ami_id
  instance_type = "${var.instance_type}"

  iam_instance_profile = var.iam_instance_profile
  key_name                    = aws_key_pair.key-pair.key_name  
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.allow_ssh.id]
  subnet_id                   = var.subnet_id
  user_data_base64            = base64encode(file("../modules/bastion/user_data.sh"))

  tags = {
    Name = "${var.project_name}-bastion"
  }
}
