terraform {
  required_providers {
    jamfplatform = {
      source  = "Jamf-Concepts/jamfplatform"
      version = ">= 0.5.0"
    }
  }
}

# Demo resource to create a smart computer group
resource "jamfplatform_device_group" "demo_computer_group" {
  name        = "Jamf Platform Demo Target Group"
  group_type  = "smart"
  device_type = "computer"
  criteria = [
    {
      criteria = "Operating System Version"
      operator = "greater than or equal"
      value    = "26.0"
    }
  ]
}

# Add data source and resource blocks below this line as required
