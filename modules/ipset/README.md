# ipset

Create [WAFv2 ipset](https://docs.aws.amazon.com/waf/latest/APIReference/API_IPSet.html) containing network CIDRs from MaxMind DB based on [ISO 3166-2](https://en.wikipedia.org/wiki/ISO_3166-2) country codes and subdivision codes.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12.26 |
| aws | >= 2.67.0 |
| maxminddb | >= 0.1.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.67.0 |
| maxminddb | >= 0.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| countries | Mapping of countries ISO codes to list of selected subdivisions. Empty list will select whole country. Requires detailed GeoIP2-City database to use subdivisions | `map(list(string))` | n/a | yes |
| description | Descriptions for ip set | `string` | `null` | no |
| ip\_address\_version | IPV4 or IPV6 | `string` | `"IPV4"` | no |
| name | Name for ip set | `string` | n/a | yes |
| scope | IP Set scope. CLOUDFRONT or REGIONAL | `string` | n/a | yes |
| tags | Mapping of additional tags for resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | ARN of created IP Set |
| id | ID of created IP Set |
| name | Name of created IP Set |
