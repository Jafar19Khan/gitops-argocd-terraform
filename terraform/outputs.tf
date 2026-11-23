output "ec2_public_ip" {
  value = aws_instance.k3s_argocd_server.public_ip
}

output "argocd_ui_url" {
  value = "https://${aws_instance.k3s_argocd_server.public_ip}:30443"
}

output "sample_app_url" {
  value = "http://${aws_instance.k3s_argocd_server.public_ip}:30080"
}
