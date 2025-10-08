# Audio Accessory Settings
resource "jamfplatform_blueprints_blueprint" "audio_accessory_settings" {
  name        = "Audio Accessory Settings"
  description = "Managed by Terraform"

  device_groups = [data.jamfpro_group.jamfplatform_demo_target_group.group_platform_id]

  audio_accessory_settings {
    temporary_pairing_disabled = false
    unpairing_time_policy      = "Hour"
    unpairing_time_hour        = 22
  }
}
