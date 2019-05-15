output "public_subnet_ids" {
  value = ["${aws_default_subnet.default_subnet.*.id}"]
}

output "vpc_id" {
  value = "${aws_default_vpc.default_vpc.id}"
}

output "public_security_group_id" {
  value = "${aws_security_group.allow_all_tls.id}"
}


output "resources_zone_id" {
  value = "${aws_route53_zone.resources.zone_id}"
}

output "resources_zone_name" {
  value = "${aws_route53_zone.resources.name}"
}

output "resources_name_servers" {
  value = "${aws_route53_zone.resources.name_servers}"
}