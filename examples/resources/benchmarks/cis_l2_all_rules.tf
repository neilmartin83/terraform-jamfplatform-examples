# CIS Level 2 Benchmark - All Sources, All Rules
data "jamfplatform_cbengine_rules" "cis_lvl2" {
  baseline_id = "cis_lvl2"
}

resource "jamfplatform_cbengine_benchmark" "cis_lvl2_all" {
  title              = "CIS Level 2 Benchmark - All Sources, All Rules"
  description        = "Managed by Terraform"
  source_baseline_id = "cis_lvl2"

  sources = [
    for s in data.jamfplatform_cbengine_rules.cis_lvl2.sources : {
      branch   = s.branch
      revision = s.revision
    }
  ]

  rules = [
    for r in data.jamfplatform_cbengine_rules.cis_lvl2.rules : {
      id      = r.id
      enabled = r.enabled
    }
  ]

  target_device_group = data.jamfpro_group.jamfplatform_demo_target_group.group_platform_id
  enforcement_mode    = "MONITOR"
}
