# CIS Level 1 Benchmark - All Sources, All Rules
data "jamfplatform_cbengine_rules" "cis_lvl1" {
  baseline_id = "cis_lvl1"
}

resource "jamfplatform_cbengine_benchmark" "cis_lvl1_all" {
  title              = "CIS Level 1 Benchmark - All Sources, All Rules"
  description        = "Managed by Terraform"
  source_baseline_id = "cis_lvl1"

  sources = [
    for s in data.jamfplatform_cbengine_rules.cis_lvl1.sources : {
      branch   = s.branch
      revision = s.revision
    }
  ]

  rules = [
    for r in data.jamfplatform_cbengine_rules.cis_lvl1.rules : {
      id      = r.id
      enabled = r.enabled
    }
  ]

  target_device_group = jamfplatform_device_group.demo_computer_group.id
  enforcement_mode    = "MONITOR"
}
