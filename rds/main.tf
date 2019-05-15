provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

terraform {
  backend "s3" {
    bucket         = "com.scrapingasaservice.terraform"
    key            = "rds.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-remote-state-lock"
  }
}

data "terraform_remote_state" "networking" {
  backend   = "s3"
  workspace = "${terraform.workspace}"
  config {
    bucket = "com.scrapingasaservice.terraform"
    key    = "networking.tfstate"
    region = "${var.region}"
  }
}

locals {
  timestamp           = "${timestamp()}"
  timestamp_sanitized = "${replace("${local.timestamp}", "/[-| |T|Z|:]/", "")}"
}

output "dns_zone_id" {
  value = "${data.terraform_remote_state.networking.root_domain_zone_id}"
}