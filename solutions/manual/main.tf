terraform {
  required_providers {
    aws = {
      version = "~>3.61.0"
      source  = "hashicorp/aws"
    }
  }
  backend "s3" {
    bucket         = "local-tf-chicken-before-egg"
    dynamodb_table = "local-tf-chicken-before-egg-locks"
    encrypt        = true
    key            = "./terraform.tfstate"
    region         = "us-east-1"
  }
}

provider "aws" {
  alias  = "main"
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform_state" {
  provider = aws.main
  bucket   = "local-tf-chicken-before-egg"

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

resource "aws_dynamodb_table" "terraform_locks" {
  provider = aws.main

  name = "local-tf-chicken-before-egg-locks"
  # On Demand and no need to provision WCU or RCU `
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

