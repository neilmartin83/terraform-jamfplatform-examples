# Math Settings
resource "jamfplatform_blueprints_blueprint" "math_settings" {
  name        = "Math Settings"
  description = "Managed by Terraform"
  deployed    = false

  device_groups = [jamfplatform_device_group.demo_computer_group.id]

  math_settings = {
    calculator_basic_mode_add_square_root  = true
    calculator_scientific_mode_enabled     = true
    calculator_programmer_mode_enabled     = false
    calculator_math_notes_mode_enabled     = true
    calculator_input_modes_unit_conversion = true
    calculator_input_modes_rpn             = false
    system_behavior_keyboard_suggestions   = true
    system_behavior_math_notes             = true
  }
}
