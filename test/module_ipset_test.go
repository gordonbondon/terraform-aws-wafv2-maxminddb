package test

import (
	"os"
	"path/filepath"
	"testing"

	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
	tfjson "github.com/hashicorp/terraform-json"
	"github.com/stretchr/testify/assert"
)

func TestTerraformIpSet(t *testing.T) {
	t.Parallel()

	testCases := []struct {
		name             string
		ipAddressVersion string
		countries        map[string][]string
		expectedSet      []string
	}{
		{
			name:             "one country",
			ipAddressVersion: "IPV4",
			countries:        map[string][]string{"US": {}},
			expectedSet:      []string{"216.160.83.56/29"},
		},
	}

	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			exampleFolder := test_structure.CopyTerraformFolderToTemp(t, "../", "test/fixtures/ipset")
			planFilePath := filepath.Join(exampleFolder, "plan.out")

			t.Cleanup(func() {
				os.RemoveAll(exampleFolder)
			})

			terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
				TerraformDir: exampleFolder,
				Vars: map[string]interface{}{
					"ip_address_version": tc.ipAddressVersion,
					"countries":          tc.countries,
				},
				PlanFilePath: planFilePath,
			})

			jsonPlan := terraform.InitAndPlanAndShow(t, terraformOptions)
			plan := &tfjson.Plan{}

			err := plan.UnmarshalJSON([]byte(jsonPlan))
			if err != nil {
				t.Errorf("failed unpacking plan: %v", err)
			}

			resources := plan.PlannedValues.RootModule.ChildModules[0].Resources
			var wafIpSet *tfjson.StateResource

			for _, r := range resources {
				if r.Type == "aws_wafv2_ip_set" && r.Name == "geo" {
					wafIpSet = r
				}
			}

			if wafIpSet.Name == "" {
				t.Error("required aws_wafv2_ip_set.geo missing")
			}

			actual := make([]string, len(wafIpSet.AttributeValues["addresses"].([]interface{})))

			for i, a := range wafIpSet.AttributeValues["addresses"].([]interface{}) {
				actual[i] = a.(string)
			}

			assert.Equal(t, tc.expectedSet, actual)
		})
	}
}
