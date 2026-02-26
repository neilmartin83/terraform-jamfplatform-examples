# Software Update
resource "jamfplatform_blueprints_blueprint" "software_update_manual" {
  name        = "Software Update - Manual Targeted Update"
  description = "Managed by Terraform"
  deployed    = false

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  software_update = {
    target_os_version      = "26.2"
    target_local_date_time = "2025-12-25T12:00:00"
    details_url_value      = "https://soundmacguy.wordpress.com"
  }
}

resource "jamfplatform_blueprints_blueprint" "software_update_automatic" {
  name        = "Software Update - Automatic Update"
  description = "Managed by Terraform"
  deployed    = false

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  software_update = {
    deployment_time    = "17:30"
    enforce_after_days = 14
  }
}
