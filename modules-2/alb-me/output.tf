output "target_group_arn" {
  description = "ALB Target Group ARN"
  value       = aws_lb_target_group.this.arn
}

output "dns_name" {
  description = "DNS Name ALB"
  value       = aws_alb.this.dns_name
}