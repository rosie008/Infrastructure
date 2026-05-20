resource "aws_instance" "k8s-worker" {
  ami           = var.ami_id
  instance_type = "${var.instance_type}"

  iam_instance_profile        = var.iam_instance_profile
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  subnet_id                   = var.subnet_id
  user_data_base64            = base64encode(file("../modules/k8s-worker/user_data.sh"))

  tags = {
    Name = "${var.project_name}-k8s-worker"
  }
}
