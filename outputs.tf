output "mivu_grafana" {
  description = "This is the public IP of MiVu Server"
  value       = "http://${aws_instance.mivu_server.public_ip}:3000"
}

output "mivu_chronograf" {
  description = "This is the public IP of MiVu Server"
  value       = "http://${aws_instance.mivu_server.public_ip}:8888"
}
