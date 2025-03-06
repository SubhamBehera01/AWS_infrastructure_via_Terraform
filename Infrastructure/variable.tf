variable "aws_region" { default = "ap-south-1" }

variable "vpc_cidr" { default = "10.0.0.0/16" }

variable "public_subnet_1a_cidr" { default = "10.0.1.0/24" }

variable "public_subnet_1b_cidr" { default = "10.0.2.0/24" }

variable "private_subnet_1a_cidr" { default = "10.0.3.0/24" }

variable "private_subnet_1b_cidr" { default = "10.0.4.0/24" }

variable "ami_id" { default = "ami-00bb6a80f01f03502" }  # Change to latest Ubuntu AMI

variable "instance_type" { default = "t2.micro" }

variable "aws_key_pair" {
  default = "key-for-terra"
}

variable "db_username" {
  default = "admin"
}

variable "db_password" {
  default = "password123"
}