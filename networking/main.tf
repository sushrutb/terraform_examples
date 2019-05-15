terraform {
  backend "s3" {
    bucket         = "name_of_bucket_created_in_remote_state_module"
    # Each module should have a separate state file.
    key            = "networking.tfstate"
    encrypt        = true
    dynamodb_table = "terraform-remote-state-lock"
  }
}

provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

