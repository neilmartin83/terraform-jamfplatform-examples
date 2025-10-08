# Get all baselines and all rules from the Compliance Benchmark Engine API and output to a CSV file
data "jamfplatform_cbengine_baselines" "all" {}

data "jamfplatform_cbengine_rules" "all" {
  for_each    = { for b in data.jamfplatform_cbengine_baselines.all.baselines : b.id => b if b.id != "" }
  baseline_id = each.value.baseline_id
}

data "jamfplatform_cbengine_baselines" "all" {}

data "jamfplatform_cbengine_rules" "all" {
  for_each    = { for b in data.jamfplatform_cbengine_baselines.all.baselines : b.id => b if b.id != "" }
  baseline_id = each.value.id
}

resource "local_file" "all_benchmarks_all_rules_csv" {
  filename = "${path.module}/all_benchmarks_all_rules.csv"
  content = join("\n", concat([
    # CSV Header
    "baseline_id,baseline_internal_id,baseline_title,baseline_description,baseline_rule_count,source_branch,source_revision,rule_id,rule_title,rule_description,rule_enabled,rule_section,odv_type,odv_value,odv_hint,odv_placeholder,odv_validation_min,odv_validation_max,odv_validation_regex,odv_validation_enum_values,dependencies,references,supported_os"
    ], flatten([
      for b in data.jamfplatform_cbengine_baselines.all.baselines : [
        for r in data.jamfplatform_cbengine_rules.all[b.id].rules : join(",", [
          # Baseline fields
          "\"${b.baseline_id}\"",
          "\"${b.id}\"",
          "\"${replace(b.title, "\"", "\"\"")}\"",
          "\"${replace(b.description, "\"", "\"\"")}\"",
          "${b.rule_count}",
          # Source fields (use first source if available)
          "\"${length(data.jamfplatform_cbengine_rules.all[b.id].sources) > 0 ? data.jamfplatform_cbengine_rules.all[b.id].sources[0].branch : ""}\"",
          "\"${length(data.jamfplatform_cbengine_rules.all[b.id].sources) > 0 ? data.jamfplatform_cbengine_rules.all[b.id].sources[0].revision : ""}\"",
          # Rule fields
          "\"${r.id}\"",
          "\"${replace(r.title, "\"", "\"\"")}\"",
          "\"${replace(r.description, "\"", "\"\"")}\"",
          "${r.enabled}",
          "\"${r.section_name != null ? replace(r.section_name, "\"", "\"\"") : ""}\"",
          # ODV fields
          "\"${r.odv_type != null ? r.odv_type : ""}\"",
          "\"${r.odv_value != null ? replace(r.odv_value, "\"", "\"\"") : ""}\"",
          "\"${r.odv_hint != null ? replace(r.odv_hint, "\"", "\"\"") : ""}\"",
          "\"${r.odv_placeholder != null ? replace(r.odv_placeholder, "\"", "\"\"") : ""}\"",
          "${r.odv_validation_min != null ? r.odv_validation_min : ""}",
          "${r.odv_validation_max != null ? r.odv_validation_max : ""}",
          "\"${r.odv_validation_regex != null ? replace(r.odv_validation_regex, "\"", "\"\"") : ""}\"",
          "\"${r.odv_validation_enum_values != null && length(r.odv_validation_enum_values) > 0 ? join("; ", r.odv_validation_enum_values) : ""}\"",
          # Dependencies, references, supported OS
          "\"${r.depends_on != null && length(r.depends_on) > 0 ? join("; ", r.depends_on) : ""}\"",
          "\"${r.references != null && length(r.references) > 0 ? join("; ", r.references) : ""}\"",
          "\"${r.supported_os != null ? join("; ", [for os in r.supported_os : "${os.os_type} ${os.os_version != null ? "v${os.os_version}" : ""} (${os.management_type})"]) : ""}\""
        ])
      ]
  ])))
}
