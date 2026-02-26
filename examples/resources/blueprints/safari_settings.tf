# Safari Settings
resource "jamfplatform_blueprints_blueprint" "safari_settings" {
  name        = "Safari Settings"
  description = "Managed by Terraform"
  deployed    = false

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  safari_settings = {
    accept_cookies                  = "VisitedWebsites"
    allow_disabling_fraud_warning   = false
    allow_history_clearing          = false
    allow_javascript                = true
    allow_private_browsing          = false
    allow_popups                    = false
    allow_summary                   = true
    new_tab_start_page_type         = "Home"
    new_tab_start_page_homepage_url = "https://company.com"
  }
}
