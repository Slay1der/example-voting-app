output "vpc_id" {
  value = data.aws_vpc.default.id
}

output "subnet_ids" {
  value = data.aws_subnets.default.ids
}
output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "kubeconfig_command" {
  value = "aws eks update-kubeconfig --region us-west-2 --name ${aws_eks_cluster.main.name}"
}
