# Root domain for all resources.
resource "aws_route53_zone" "resources" {
  name = "${terraform.env}-resources.${var.domain_name}"
}
