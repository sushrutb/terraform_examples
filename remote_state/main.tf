resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = "${var.bucket_name}"
  region = "${var.region}"
  acl    = "private"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }

  tags {
    Name = "S3 Remote State For Terraform"
  }
}

output "s3_bucket_url" {
  value = "${aws_s3_bucket.terraform_remote_state.bucket_domain_name}"
}

resource "aws_dynamodb_table" "terraform_remote_state_lock" {

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key       = "LockID"
  name           = "terraform-remote-state-lock"
  read_capacity  = 2
  write_capacity = 2
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}
