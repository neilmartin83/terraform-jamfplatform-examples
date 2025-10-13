# NIST 800-53 Rev 5 - Moderate Benchmark - All Sources, All Rules
data "jamfplatform_cbengine_rules" "nist_800-53r5_moderate" {
  baseline_id = "800-53r5_moderate"
}

resource "jamfplatform_cbengine_benchmark" "nist_800-53r5_moderate_all" {
  title              = "NIST 800-53 Rev 5 - Moderate Benchmark - All Sources, All Rules"
  description        = "Managed by Terraform"
  source_baseline_id = "800-53r5_moderate"

  sources = [
    for s in data.jamfplatform_cbengine_rules.nist_800-53r5_moderate.sources : {
      branch   = s.branch
      revision = s.revision
    }
  ]

  rules = [
    for r in data.jamfplatform_cbengine_rules.nist_800-53r5_moderate.rules : {
      id      = r.id
      enabled = r.enabled
    }
  ]

  target_device_group = data.jamfpro_group.jamfplatform_demo_target_group.group_platform_id
  enforcement_mode    = "MONITOR"
}
