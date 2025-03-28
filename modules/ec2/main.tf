resource "aws_instance" "ec2-instance" {
  ami                    = var.ec2_config.ami
  instance_type          = var.ec2_config.instance_type
  key_name               = var.ec2_config.key_name
  vpc_security_group_ids = var.ec2_config.vpc_security_group_ids
  subnet_id              = var.ec2_config.subnet_id
#   user_data              = file("workstation.sh")
  tags = var.ec2_config.tags

}
