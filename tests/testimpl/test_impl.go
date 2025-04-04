package testimpl

import (
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
)

func TestDNSZone(t *testing.T, ctx types.TestContext) {

	subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionID) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID is not set in the environment variables ")
	}

	credential, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}
	if credential == nil {
		t.Fatal("Failed to create azidentity credential")
	}

	// options := arm.ClientOptions{
	// 	ClientOptions: azcore.ClientOptions{
	// 		Cloud: cloud.AzurePublic,
	// 	},
	// }

	t.Run("dnsZoneExists", func(t *testing.T) {
		// if ctx == nil {
		// 	t.Fatal("Test context should not be nil")
		// }
		if ctx.TerratestTerraformOptions() == nil {
			t.Fatal("Expected ctx.TerratestTerraformOptions() to be set")
		}
		defer terraform.Destroy(t, ctx.TerratestTerraformOptions())

		terraform.InitAndApply(t, ctx.TerratestTerraformOptions())
		// output := terraform.Output(t, ctx.TerratestTerraformOptions(), "hello_world")

	})
}
