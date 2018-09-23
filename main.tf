terraform {
    required_version = "> 0.7.0"
}

provider "aws" {
  version = "~> 1.16"
  region  = "${var.aws_region}"
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {}


data "template_file" "s3_policy" {
  template = "${file("policy.json")}"
  vars {
    prefix = "${var.prefix}"
    bucket_name = "${var.prefix}-${var.bucket}"
  }
}

resource "aws_s3_bucket" "s3-terraform-state-storage" {
  bucket = "${var.prefix}-${var.bucket}"
  acl    = "private"
  force_destroy = true

  versioning {
      enabled = false
    }
 
    lifecycle {
      prevent_destroy = false
    }
 
    tags {
      Organization = "${var.organization}"
      Description = "S3 Remote Terraform State Store"
    }     
}


# create a dynamodb table for locking the state file
resource "aws_dynamodb_table" "dynamodb-terraform-state-lock" {
  name = "${var.prefix}-${var.table}"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20
 
  attribute {
    name = "LockID"
    type = "S"
  }
 
  tags {
    Organization = "${var.organization}"
    Description = "DynamoDB Terraform State Lock Table"
  }
}

output "s3_state_bucket_arn" {
  value = "${aws_s3_bucket.s3-terraform-state-storage.arn}"
}