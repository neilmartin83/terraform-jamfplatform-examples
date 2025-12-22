# Disk Management Settings
resource "jamfplatform_blueprints_blueprint" "disk_management" {
  name        = "Disk Management"
  description = "Managed by Terraform"

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  disk_management_settings {
    external_storage = "ReadOnly"
    network_storage  = "Disallowed"
  }
}
