## Configure provider
provider "aws" {
  region  = "us-west-2"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.46"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.1"
    }
  }

  required_version = ">= 0.13"
}