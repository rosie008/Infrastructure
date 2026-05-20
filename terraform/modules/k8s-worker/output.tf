output "public_ip" {
  value = aws_instance.k8s-worker.public_ip
}

output "private_ip" {
  value = aws_instance.k8s-worker.private_ip
}