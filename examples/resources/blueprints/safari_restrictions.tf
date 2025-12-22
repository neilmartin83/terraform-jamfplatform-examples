# Legacy Restrictions Payload with Safari-specific restrictions
resource "jamfplatform_blueprints_blueprint" "legacy_payload_restrictions_safari" {
  name        = "Restrictions - Safari"
  description = "Managed by Terraform"

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  legacy_payloads = jsonencode([
    {
      allowSafariHistoryClearing = false
      allowSafariPrivateBrowsing = false
      payloadType                = "com.apple.applicationaccess"
      payloadIdentifier          = "da0ac44c-419e-43ff-b300-00b0e645fa7e"
    }
  ])
}
