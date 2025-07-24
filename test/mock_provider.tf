provider "aws" {
  region = var.region
  
  # Skip credential validation for mock testing
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  
  # Use mock endpoints
  endpoints {
    ec2            = "http://localhost:4566"
    eks            = "http://localhost:4566"
    iam            = "http://localhost:4566"
    kms            = "http://localhost:4566"
    cloudwatch     = "http://localhost:4566"
    autoscaling    = "http://localhost:4566"
    sts            = "http://localhost:4566"
  }
  
  # Mock account ID and partition
  default_tags {
    tags = {
      Environment = "test"
      ManagedBy   = "terraform"
    }
  }
}

# Mock data for availability zones
data "aws_availability_zones" "available" {
  state = "available"
  
  # Override with mock data
  lifecycle {
    postcondition {
      condition     = true
      error_message = "Mock AZs available"
    }
  }
}

# Mock random string for testing
resource "random_string" "suffix" {
  length  = 8
  special = false
}