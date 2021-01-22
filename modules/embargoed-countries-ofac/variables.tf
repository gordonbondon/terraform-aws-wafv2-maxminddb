variable "embargoed_countries" {
  description = "List of ISO codes for embargoed countries"
  type        = list(string)
  default = [
    "BI", # Burundi
    "BY", # Belarus
    "CD", # Congo, the Democratic Republic of the
    "CF", # Central African Republic
    "CU", # Cuba
    "IQ", # Iraq
    "IR", # Iran
    "LB", # Lebanon
    "LY", # Libya
    "SD", # Sudan
    "SO", # Somalia
    "SS", # South Sudan
    "SY", # Syrian Arab Republic
    "VE", # Venezuela, Bolivarian Republic of
    "ZW", # Zimbabwe
  ]
}

variable "embargoed_subdivisions" {
  description = "Mapping of embargoed subdivisions. Requires GeoIP2 City mmdb touse subdivisions"
  type        = map(list(string))
  default = {
    "UA" = ["40", "43"] # Crimea Region of Ukraine (including Sevastopol)
  }
}

variable "embargoed_ips" {
  description = "List of embargoed IPs by type"
  type        = map(list(string))
  default = {
    "IPV4" = ["175.45.176.0/22"] # North Korea
  }
}

variable "name_prefix" {
  description = "Name prefix for created resources"
  type        = string
  default     = "embargoed-countries"
}

variable "scope" {
  description = "IP Set scope. CLOUDFRONT or REGIONAL"
  type        = string
}

variable "priority" {
  description = "Priority for rules in rule group"
  type        = number
  default     = 0
}

variable "visibility_config" {
  description = "Visibility config for WAF rule group and for each rule"
  type = object({
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  })
  default = {
    cloudwatch_metrics_enabled = false
    metric_name                = "embargoed-territories"
    sampled_requests_enabled   = false
  }
}

variable "tags" {
  description = "Mapping of additional tags for resource"
  type        = map(string)
  default     = {}
}
