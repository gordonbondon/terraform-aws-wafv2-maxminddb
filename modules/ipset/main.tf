data "maxminddb_country_cidrs" "ipset" {
  ip_address_version = var.ip_address_version

  dynamic "country" {
    for_each = var.countries

    content {
      iso_code     = country.key
      subdivisions = country.value
    }
  }
}

resource "aws_wafv2_ip_set" "geo" {
  name               = var.name
  description        = var.description
  scope              = var.scope
  ip_address_version = var.ip_address_version
  addresses          = data.maxminddb_country_cidrs.ipset.cidrs

  tags = var.tags
}
