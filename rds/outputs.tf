output "rds_cluster_address" {
  value = "${aws_rds_cluster.aurora_cluster.endpoint}"
}

output "rds_reader_endpoint" {
  value = "${aws_rds_cluster.aurora_cluster.reader_endpoint}"
}