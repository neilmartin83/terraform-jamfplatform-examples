# CIS Level 1 Benchmark - Custom Rules with ODV
data "jamfplatform_cbengine_rules" "cis_lvl1" {
  baseline_id = "cis_lvl1"
}

resource "jamfplatform_cbengine_benchmark" "custom_cis_lvl1" {
  title              = "CIS Level 1 Benchmark - Custom Rules with ODV"
  description        = "Managed by Terraform"
  source_baseline_id = "cis_lvl1"

  sources = [
    for s in data.jamfplatform_cbengine_rules.cis_lvl1.sources : {
      branch   = s.branch
      revision = s.revision
    }
  ]

  rules = [
    {
      id        = "system_settings_time_server_configure"
      enabled   = true
      odv_value = "ntp.jamf.com"
    },
    {
      id      = "system_settings_critical_update_install_enforce"
      enabled = true
    }
  ]
  target_device_group = data.jamfpro_group.jamfplatform_demo_target_group.group_platform_id
  enforcement_mode    = "MONITOR_AND_ENFORCE"
}
