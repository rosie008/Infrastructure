output "public_ip" {
  value = aws_instance.rancher-ui.public_ip
}

output "private_ip" {
  value = aws_instance.rancher-ui.private_ip
}