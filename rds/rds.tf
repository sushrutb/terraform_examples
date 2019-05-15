resource "aws_db_subnet_group" "aurora_db_subnet_group" {
  name = "${terraform.workspace}_aurora_db_subnet_group"

  subnet_ids = ["${data.terraform_remote_state.networking.public_subnet_ids}"]

  tags {
    Name      = "aurora_db_subnet_group"
    Workspace = "${terraform.workspace}"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier = "${terraform.workspace}-aurora-cluster"
  database_name      = "${terraform.workspace}_db"

  master_username = "${var.rds_master_username}"
  master_password = "${var.rds_master_password}"

  backup_retention_period      = 14
  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "wed:03:00-wed:04:00"

  db_subnet_group_name = "${aws_db_subnet_group.aurora_db_subnet_group.name}"

  vpc_security_group_ids = ["${data.terraform_remote_state.networking.public_security_group_id}"]

  final_snapshot_identifier = "final-snapshot-${terraform.workspace}-db-${local.timestamp_sanitized}"

  engine         = "aurora-mysql"
  engine_version = "5.7.12"
  engine_mode    = "provisioned"
  port           = 6000

  tags {
    Name      = "aurora_cluster"
    Workspace = "${terraform.workspace}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
  # Change count appropriately.
  count                = 1
  instance_class       = "db.t2.small"
  db_subnet_group_name = "${aws_db_subnet_group.aurora_db_subnet_group.name}"
  publicly_accessible  = true
  cluster_identifier   = "${aws_rds_cluster.aurora_cluster.id}"

  engine         = "aurora-mysql"
  engine_version = "5.7.12"

  tags {
    Name      = "aurora_cluster_instance"
    Workspace = "${terraform.workspace}"
  }
}

resource "aws_route53_record" "writer_db" {
  zone_id = "${data.terraform_remote_state.networking.resources_zone_id}"
  name    = "db.${data.terraform_remote_state.networking.resources_zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_rds_cluster.aurora_cluster.endpoint}"]
}

resource "aws_route53_record" "reader_db" {
  zone_id = "${data.terraform_remote_state.networking.resources_zone_id}"
  name    = "readerdb.${data.terraform_remote_state.networking.resources_zone_name}"
  type    = "CNAME"
  ttl     = "300"
  records = ["${aws_rds_cluster.aurora_cluster.reader_endpoint}"]
}
