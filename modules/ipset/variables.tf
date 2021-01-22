variable "countries" {
  description = "Mapping of countries ISO codes to list of selected subdivisions. Empty list will select whole country. Requires detailed GeoIP2-City database to use subdivisions"
  type        = map(list(string))
}

variable "name" {
  description = "Name for ip set"
  type        = string
}

variable "description" {
  description = "Descriptions for ip set"
  type        = string
  default     = null
}

variable "scope" {
  description = "IP Set scope. CLOUDFRONT or REGIONAL"
  type        = string
}

variable "ip_address_version" {
  description = "IPV4 or IPV6"
  type        = string
  default     = "IPV4"
}

variable "tags" {
  description = "Mapping of additional tags for resource"
  type        = map(string)
  default     = {}
}
