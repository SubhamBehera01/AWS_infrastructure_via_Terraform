
resource "aws_db_snapshot" "my_rds_snapshot" {
  db_instance_identifier = var.rds_db_instance_id
  db_snapshot_identifier = "my-rds-snapshot"

  depends_on = [var.rds_db_instance_id]
}

# Outputs
output "rds_endpoint" {
  value       = var.rds_db_instance_id
  description = "The connection endpoint for the RDS instance"
}