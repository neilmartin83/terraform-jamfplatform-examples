terraform {
  required_providers {
    jamfplatform = {
      source  = "Jamf-Concepts/jamfplatform"
    }
    jamfpro = {
      source  = "deploymenttheory/jamfpro"
      version = "0.26.0"
    }
  }
}

# Resource and data source to create a new smart computer group in Jamf Pro and read its Platform ID
resource "jamfpro_smart_computer_group" "jamfplatform_demo_target_group" {
  name = "Jamf Platform Demo Target Group"
}

data "jamfpro_group" "jamfplatform_demo_target_group" {
  group_jamfpro_id = jamfpro_smart_computer_group.jamfplatform_demo_target_group.id
  group_type       = "COMPUTER"
}

# Add data source and resource blocks below this line as required
