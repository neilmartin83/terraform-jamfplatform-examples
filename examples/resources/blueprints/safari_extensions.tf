# Safari Extensions
resource "jamfplatform_blueprints_blueprint" "safari_extensions" {
  name        = "Safari Extensions"
  description = "Managed by Terraform"

  device_groups = [data.jamfpro_group.jamfplatform_demo_target_group.group_platform_id]

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
