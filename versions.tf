terraform {
  required_version = ">= 0.12.26"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.67.0"
    }
    maxminddb = {
      source  = "gordonbondon/maxminddb"
      version = ">= 0.1.0"
    }
  }
}
