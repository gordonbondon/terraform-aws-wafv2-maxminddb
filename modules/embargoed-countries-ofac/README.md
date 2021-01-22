# embargoed-countries-ofac

Protect your infrastructure against incoming traffic from embargoed countries as defined by [OFAC](https://home.treasury.gov/policy-issues/financial-sanctions/sanctions-programs-and-country-information).

This module will create a [WAF Rule Group](https://docs.aws.amazon.com/waf/latest/developerguide/waf-rule-groups.html) that you can use
in your Web ACLs.

> **IMPORTANT NOTES:**
> It’s your own responsibility to keep the embargoed countries list up to date and valid going forward

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| embargoed\_countries | List of ISO codes for embargoed countries | `list(string)` | <pre>[<br>  "BI",<br>  "BY",<br>  "CD",<br>  "CF",<br>  "CU",<br>  "IQ",<br>  "IR",<br>  "LB",<br>  "LY",<br>  "SD",<br>  "SO",<br>  "SS",<br>  "SY",<br>  "VE",<br>  "ZW"<br>]</pre> | no |
| embargoed\_ips | List of embargoed IPs by type | `map(list(string))` | <pre>{<br>  "IPV4": [<br>    "175.45.176.0/22"<br>  ]<br>}</pre> | no |
| embargoed\_subdivisions | Mapping of embargoed subdivisions. Requires GeoIP2 City mmdb touse subdivisions | `map(list(string))` | <pre>{<br>  "UA": [<br>    "40",<br>    "43"<br>  ]<br>}</pre> | no |
| name\_prefix | Name prefix for created resources | `string` | `"embargoed-countries"` | no |
| priority | Priority for rules in rule group | `number` | `0` | no |
| scope | IP Set scope. CLOUDFRONT or REGIONAL | `string` | n/a | yes |
| tags | Mapping of additional tags for resource | `map(string)` | `{}` | no |
| visibility\_config | Visibility config for WAF rule group and for each rule | <pre>object({<br>    cloudwatch_metrics_enabled = bool<br>    metric_name                = string<br>    sampled_requests_enabled   = bool<br>  })</pre> | <pre>{<br>  "cloudwatch_metrics_enabled": false,<br>  "metric_name": "embargoed-territories",<br>  "sampled_requests_enabled": false<br>}</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| group\_rule\_arn | ARN of created group rule |
| group\_rule\_id | ID of created group rule |
| group\_rule\_name | Name of created group rule |
