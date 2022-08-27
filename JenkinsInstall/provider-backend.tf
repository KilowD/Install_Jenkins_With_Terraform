terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials" //aws credentials home directory
  profile                 = "terraform-connect"
}


# configure S3 Buckect
resource "aws_s3_bucket" "terraform_state" {
  bucket = "mys3-bucket-terraform-state"
  versioning {
    enabled = true
  }
  server_side_encryption_configuration { //make sure the state file is ecrypted
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
# setup a locking mechanism so that only one user can make changes at a given time --use DynamoDB table 
resource "aws_dynamodb_table" "terraform_DynamoDb-Example" {
  name         = "terraform-State-Locking"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}

/* 
# setup the backend -first run  the terraform apply without the below configure..comment it out first
# then uncomment it and re-run terraform init again
terraform {
  backend "s3" {
    bucket         = "mys3-bucket-terraform-state"
    key            = "global/S3/terraform.tfstate" //path  i want to use for my state file
    region         = "us-east-1"
    dynamodb_table = "terraform-State-Locking"
    encrypt        = true
    profile        = "terraform-connect"
  }
} */
