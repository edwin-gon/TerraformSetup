terraform {
  required_providers {
    aws = {
      version = "~>3.61.0"
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias  = "main"
  region = var.region

  default_tags {
    tags = merge(var.custom_tags, {
      ImplementationType = var.naming_prefix
    })
  }
}



resource "aws_s3_bucket" "remote_state" {
  provider = aws.main
  bucket   = var.bucket_name

  # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning to see the full revision history of state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption for all objects
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "lock_table" {
  provider = aws.main

  name = var.table_name
  # On Demand and no need to provision WCU or RCU `
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

