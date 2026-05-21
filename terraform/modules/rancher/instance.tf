resource "aws_instance" "rancher-ui" {
  ami           = var.ami_id
  instance_type = "${var.instance_type}"

  iam_instance_profile        = var.iam_instance_profile
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  subnet_id                   = var.subnet_id
  user_data_base64            = base64encode(file("../modules/rancher/user_data.sh"))

  tags = {
    Name = "${var.project_name}-rancher-ui"
  }
}
