# Terraform AWS Infrastructure

This Terraform project is used to provision and manage AWS Set up 2 new Nginx Web Servers in the Private subnet and they are under the load balancer and also Create a MySQL database on RDS and take a snapshot using Terraform Generate an EC2 AMI backup template with the help of Terraform.

## Project Structure

```
Terraform/
├── Backup/
│   ├── EC2/
│   │   ├── AMI_Backup.tf
│   │   ├── main.tf
│   │   ├── variable.tf
│   ├── RDS/
│   │   ├── main.tf
│   │   ├── RDS_Backup.tf
│   │   ├── variable.tf
├── Infrastructure/
│   ├── ec2.tf
│   ├── main.tf
│   ├── rds.tf
│   ├── variable.tf
│   ├── vpc.tf
```

## Prerequisites

- Install [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS IAM user with necessary permissions
- Configure AWS credentials using `aws configure`

## Usage

### Initialize Terraform

Run the following command to initialize the working directory:

```sh
terraform init
```

### Plan Infrastructure

To see what Terraform will create, run:

```sh
terraform plan
```

### Apply Changes

To create the AWS infrastructure, run:

```sh
terraform apply 
```

### Destroy Infrastructure

To delete the AWS resources provisioned by Terraform, run:

```sh
terraform destroy 
```

## Key Resources

### EC2 Instances

- Defined in `ec2.tf`
- AMI backups configured in `AMI_Backup.tf`

### RDS Instance

- Defined in `RDS/main.tf`
- Security group restrictions
- Automated backups (`backup_retention_period = 7` keeps backups for 7 days)

### Networking (VPC, Security Groups)

- Defined in `vpc.tf`
- Restricts access to ALB and RDS

## Troubleshooting

If you encounter errors like `Reference to undeclared resource`, ensure that:

- The missing resource is properly defined in Terraform files
- You have initialized the working directory (`terraform init`)
- You are in the correct directory when running Terraform commands

## Notes

- The `skip_final_snapshot = true` in RDS prevents the final snapshot before deletion.
- Ensure your security groups and IAM roles are correctly configured to avoid connectivity issues.

---

Developed by **Subham**

