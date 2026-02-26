# Software Update Settings
resource "jamfplatform_blueprints_blueprint" "software_update_settings" {
  name        = "Software Update Settings"
  description = "Managed by Terraform"
  deployed    = false

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  software_update_settings = {
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

    beta_offer_programs = [
      {
        token       = "beta-token-1"
        description = "iOS 18 Beta Program"
      },
      {
        token       = "beta-token-2"
        description = "macOS Sequoia Beta Program"
      }
    ]
  }
}
