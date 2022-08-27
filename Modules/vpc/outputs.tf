output "ec2_security_group_ids" {
  description = "security group id for the ec2 instance"
  value       = aws_security_group.ec2_security_group.id
}
output "subnet_id" {
  description = "default subnet id for the ec2 instance"
  value       = aws_default_subnet.default_az1.id
}
