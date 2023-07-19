output "mivu_grafana" {
  description = "This is the public IP of MiVu Server"
  value       = "http://${aws_eip.server_eip.public_ip}:3000"
}

output "mivu_chronograf" {
  description = "This is the public IP of MiVu Server"
  value       = "http://${aws_eip.server_eip.public_ip}:8888"
}
