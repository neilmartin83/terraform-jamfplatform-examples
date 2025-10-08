terraform {
  required_version = "1.10.6"
  required_providers {
    jamfplatform = {
      source  = "Jamf-Concepts/jamfplatform"
      version = "0.1.3"
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
# Software Update Settings
resource "jamfplatform_blueprints_blueprint" "software_update_settings" {
  name        = "Software Update Settings"
  description = "Managed by Terraform"

  device_groups = [data.jamfpro_group.jamfplatform_demo_target_group.group_platform_id]

  software_update_settings {
    allow_standard_user_os_updates           = true
    automatic_download                       = "AlwaysOn"
    automatic_install_os_updates             = "AlwaysOn"
    automatic_install_security_updates       = "AlwaysOn"
    beta_program_enrollment                  = "Allowed"
    deferral_combined_period_days            = 7
    deferral_major_period_days               = 30
    deferral_minor_period_days               = 14
    deferral_system_period_days              = 3
    notifications_enabled                    = true
    rapid_security_response_enabled          = true
    rapid_security_response_rollback_enabled = false
    recommended_cadence                      = "Newest"

    # Beta offer programs
    beta_offer_programs {
      token       = "beta-token-1"
      description = "iOS 18 Beta Program"
    }

    beta_offer_programs {
      token       = "beta-token-2"
      description = "macOS Sequoia Beta Program"
    }
  }
}
