output "rupa_lb_dns" {
  value = aws_lb.rupa_lb.dns_name
}

output "rupa_ecr_path" {
  value = aws_ecr_repository.rupa_ecr.repository_url
}
