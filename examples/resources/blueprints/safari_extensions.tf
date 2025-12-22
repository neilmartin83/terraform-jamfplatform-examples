# Safari Extensions
resource "jamfplatform_blueprints_blueprint" "safari_extensions" {
  name        = "Safari Extensions"
  description = "Managed by Terraform"

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  safari_extensions {
    managed_extensions {
      extension_id     = "com.example.adblock"
      state            = "Allowed"
      private_browsing = "AlwaysOff"
      allowed_domains {
        domain = "*.company.com"
      }
      denied_domains {
        domain = "*.social-media.com"
      }
    }
  }
}
