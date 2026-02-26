# Audio Accessory Settings
resource "jamfplatform_blueprints_blueprint" "audio_accessory_settings" {
  name        = "Audio Accessory Settings"
  description = "Managed by Terraform"
  deployed    = false

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  audio_accessory_settings = {
    temporary_pairing_disabled = false
    unpairing_time_policy      = "Hour"
    unpairing_time_hour        = 22
  }
}
