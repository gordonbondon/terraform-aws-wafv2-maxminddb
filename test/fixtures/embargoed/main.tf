provider "aws" {
  region = "us-east-1"

  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = true
  skip_region_validation      = true

  access_key = "mock_access_key_for_tests"
  secret_key = "mock_secret_key_for_tests"
}

provider "maxminddb" {
  db_path = "../../../test-data/test-data/GeoIP2-City-Test.mmdb"
}

terraform {
  required_providers {
    maxminddb = {
      source  = "gordonbondon/maxminddb"
      version = "0.1.0"
    }
  }
}

module "embargoed_countries" {
  source = "../../../modules/embargoed-countries-ofac"

  scope = "CLOUDFRONT"
}
