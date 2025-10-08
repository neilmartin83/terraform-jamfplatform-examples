# Disk Management Settings
resource "jamfplatform_blueprints_blueprint" "disk_management" {
  name        = "Disk Management"
  description = "Managed by Terraform"

  device_groups = [data.jamfpro_group.jamfplatform_demo_target_group.group_platform_id]

  disk_management_settings {
    external_storage = "ReadOnly" # No version needed!
    network_storage  = "Disallowed"
  }
}
