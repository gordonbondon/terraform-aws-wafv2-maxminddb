module github.com/gordonbondon/terraform-aws-waf-maxminddb/test

go 1.15

require (
	github.com/gruntwork-io/terratest v0.31.4
	github.com/hashicorp/terraform-json v0.8.0
	github.com/stretchr/testify v1.6.1
	github.com/terraform-docs/terraform-docs v0.10.1
	github.com/terraform-linters/tflint v0.23.1
)

// terratest deps : (
replace (
	k8s.io/api => k8s.io/api v0.19.3
	k8s.io/apimachinery => k8s.io/apimachinery v0.19.3
	k8s.io/client-go => k8s.io/client-go v0.19.3
)
