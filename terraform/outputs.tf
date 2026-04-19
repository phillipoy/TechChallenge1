# Output ALB DNS so you can access your app
output "alb_dns_name" {
  value = aws_lb.app.dns_name
}

# Output ECS cluster name
output "ecs_cluster_name" {
  value = aws_ecs_cluster.main.name
}