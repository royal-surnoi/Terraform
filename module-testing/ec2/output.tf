output "security_group_id" {
  value = module.security_group.security_group_id
}

output "public_ip" {
  value = module.ec2_instance.public_ip
}

output "key_name" {
  value = module.key_pair.key_name
}