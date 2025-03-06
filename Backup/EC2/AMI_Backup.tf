# Create AMI Backup for Public EC2
resource "aws_ami_from_instance" "public_ec2_backup" {
  name               = "backup-public-ec2"
  source_instance_id = var.ec2_public_instance_id
  description        = "Backup of Public EC2 instance"
  depends_on         = [var.ec2_public_instance_id] 
}

# Create AMI Backup for Private EC2 in 1a
resource "aws_ami_from_instance" "private_ec2_1a_backup" {
  name               = "backup-private-ec2-1a"
  source_instance_id = var.ec2_private-1a_instance_id
  description        = "Backup of Private EC2 instance in AZ 1a"
}

# Create AMI Backup for Private EC2 in 1b
resource "aws_ami_from_instance" "private_ec2_1b_backup" {
  name               = "backup-private-ec2-1b"
  source_instance_id = var.ec2_private-1b_instance_id
  description        = "Backup of Private EC2 instance in AZ 1b"
}