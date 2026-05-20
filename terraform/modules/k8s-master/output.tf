output "public_ip" {
  value = aws_instance.k8s-master.public_ip
}

output "private_ip" {
  value = aws_instance.k8s-master.private_ip
}