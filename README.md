# Terraform Jamf Platform Examples

Example Terraform configurations demonstrating how to use the Jamf Platform Terraform provider for managing Jamf Pro resources, compliance benchmarks, and device groups.

## 🚀 Quick Start

1. **Clone this repository**

   ```bash
   git clone https://github.com/neilmartin83/terraform-jamfplatform-examples.git
   cd terraform-jamfplatform-examples
   ```

2. **Create your variables file**

   ```bash
   cp terraform.tfvars.example terraform.tfvars
   # Edit terraform.tfvars with your Jamf Platform API credentials
   ```

3. **Browse example configurations**
   - Check `examples/data_sources/` for data source examples
   - Check `examples/resources/` for resource examples
   - The root `main.tf` is your playground - copy/paste/modify data source and resource examples to try them out!

4. **Initialize and apply**

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## 🔧 Configuration

### Authentication

This repository uses a local `terraform.tfvars` file for authentication. You need to create your own `terraform.tfvars` file with your Jamf Platform API credentials.

Follow the [Getting Started](https://developer.jamf.com/platform-api/reference/getting-started-with-platform-api) guide to generate your credentials.

**Required Variables:**

Create a `terraform.tfvars` file in the root directory:

```hcl
# Jamf Platform API Configuration
jamfplatform_base_url      = "https://us.apigw.jamf.com"  # or eu.apigw.jamf.com, apac.apigw.jamf.com
jamfplatform_client_id     = "your-jamfplatform-client-id"
jamfplatform_client_secret = "your-jamfplatform-client-secret"
```

**⚠️ Security Note**: Never commit `terraform.tfvars` to version control. It's already included in `.gitignore`.

### Jamf Platform Provider

This repository demonstrates using the Jamf Platform provider for complete device management:

- **Device Groups** - Create and manage smart/static device groups natively
- **Compliance Benchmarks** - Configure security baselines (CIS, NIST 800-53)
- **Blueprints** - Manage device configurations and policies
- **Data Sources** - Query baselines, rules, and device groups

### Device Group Management

The `main.tf` shows how to create a smart computer group directly in Jamf Platform:

```hcl
# Create a smart computer group
resource "jamfplatform_device_group" "demo_computer_group" {
  name        = "Jamf Platform Demo Target Group"
  group_type  = "smart"
  device_type = "computer"
  criteria {
    criteria = "Operating System Version"
    operator = "greater than or equal"
    value    = "26.0"
  }
}

# Use the group in benchmarks and blueprints
resource "jamfplatform_cbengine_benchmark" "example" {
  # ... other configuration ...
  target_device_group = jamfplatform_device_group.demo_computer_group.id
}
```

## 📁 Repository Structure

```
terraform-jamfplatform-examples/
├── main.tf                    # Main configuration with demo device group
├── provider.tf               # Jamf Platform provider configuration
├── variables.tf              # Variable definitions
├── terraform.tfvars         # Your local variable configuration (not in git)
├── examples/
│   ├── data_sources/
│   │   └── benchmarks/
│   │       └── all_baselines_all_rules.tf  # Export all benchmarks to CSV
│   └── resources/
│       ├── benchmarks/      # Compliance benchmark examples
│       └── blueprints/      # Device configuration examples
└── README.md
```

## 📊 Current Examples

### Data Sources

- **All Baselines and Rules** (`examples/data_sources/benchmarks/all_baselines_all_rules.tf`)
  - Fetches all available compliance baselines and their rules
  - Exports comprehensive data to CSV format including ODV fields
  - Demonstrates `jamfplatform_cbengine_baselines` and `jamfplatform_cbengine_rules` data sources

### Resources

#### Benchmarks (`examples/resources/benchmarks/`)

- **CIS Level 1 & 2** - Complete compliance benchmarks with all rules
- **NIST 800-53 Rev 5** - Low, Moderate, and High security baselines
- **Custom Rules with ODV** - Demonstrates customizing rules with organization-defined values

#### Blueprints (`examples/resources/blueprints/`)

- **Software Update** - Manual targeted updates and automatic deployment
- **Software Update Settings** - Beta programs, deferrals, and update cadence
- **Passcode Policy** - Password complexity and security requirements
- **Safari Settings** - Browser configuration and restrictions
- **Safari Bookmarks & Extensions** - Managed bookmarks and extension policies
- **Disk Management** - External and network storage controls
- **Audio Accessory Settings** - Bluetooth audio device management
- **Math Settings** - Calculator and math notes configuration
- **Service Background Tasks** - Custom background services and daemons
- **Service Configuration Files** - System service configurations (SSH, PAM)

### Main Configuration

The root `main.tf` includes:

- **Jamf Platform Provider Setup** - Single provider configuration
- **Smart Computer Group Creation** - Creates a demo target group with OS version criteria
- **Ready for Extension** - Playground for testing resource and data source examples

## 🛠 Usage

### Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/neilmartin83/terraform-jamfplatform-examples.git
   cd terraform-jamfplatform-examples
   ```

2. **Create your terraform.tfvars file**

   ```bash
   # Copy the example and customize with your values
   cp terraform.tfvars.example terraform.tfvars
   ```

   Edit `terraform.tfvars` with your actual API credentials:

   ```hcl
   jamfplatform_base_url      = "https://us.apigw.jamf.com"
   jamfplatform_client_id     = "your-platform-client-id"
   jamfplatform_client_secret = "your-platform-client-secret"
   ```

3. **Initialize and run**

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### What the Example Does

The main configuration will:

- Create a smart computer group in Jamf Platform called "Jamf Platform Demo Target Group"
- Target devices running macOS 26.0 or higher
- Provide a foundation for testing benchmark and blueprint configurations from the examples

### Extending the Configuration

Copy examples from `examples/resources/` and add them to `main.tf`:

```hcl
# Add data source and resource blocks below this line as required

# Example: Add a CIS Level 1 benchmark
data "jamfplatform_cbengine_rules" "cis_lvl1" {
  baseline_id = "cis_lvl1"
}

resource "jamfplatform_cbengine_benchmark" "my_cis_benchmark" {
  title              = "My CIS Benchmark"
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
```

## 📚 Provider Documentation

This repository uses the Jamf Platform Terraform provider:

### Jamf Platform Provider (`Jamf-Concepts/jamfplatform`)

- **Purpose**: Manage Jamf Platform resources including device groups, compliance benchmarks, and blueprints
- **Version**: >= 0.5.0
- **Authentication**: OAuth2 client credentials
- **Documentation**: [Terraform Registry](https://registry.terraform.io/providers/Jamf-Concepts/jamfplatform/latest/docs)

**Key Resources:**

- `jamfplatform_device_group` - Smart and static device groups for computers and mobile devices
- `jamfplatform_cbengine_benchmark` - Compliance benchmarks (CIS, NIST 800-53)
- `jamfplatform_blueprints_blueprint` - Device configuration blueprints

**Key Data Sources:**

- `jamfplatform_cbengine_baselines` - Available compliance baselines
- `jamfplatform_cbengine_rules` - Rules for specific baselines
- `jamfplatform_device_groups` - Query existing device groups

## 🔄 GitHub Workflows

This repository includes GitHub Actions workflows for automated Terraform operations:

### Available Workflows

- **Terraform Plan (PR)** - Runs on pull requests to validate configuration and show proposed changes
- **Terraform Apply** - Runs when changes are merged to main branch or manually triggered for deployment

### Workflow Features

- **Validation**: Automatic `terraform fmt`, `terraform validate`, and `terraform plan` on PRs
- **Security**: Uses GitHub repository secrets for API credentials
- **Automation**: Applies changes automatically on merge to main branch
- **Rollback**: Includes automatic rollback (destroy) capabilities on deployment failures

### Required Secrets

If using the GitHub workflows, configure these repository secrets for sensitive credentials:

- `jamfplatform_client_id` - Your Jamf Platform API client ID
- `jamfplatform_client_secret` - Your Jamf Platform API client secret

### Required Repository Variables

Configure these repository variables for non-sensitive configuration values:

- `JAMFPLATFORM_BASE_URL` - Your Jamf Platform API base URL (e.g., `https://us.apigw.jamf.com`)

### Setting Up GitHub Repository Configuration

1. **Repository Secrets** (Settings → Secrets and variables → Actions → Secrets):
   - Add `jamfplatform_client_id` with your Jamf Platform client ID
   - Add `jamfplatform_client_secret` with your Jamf Platform client secret
   - These are encrypted and only available during workflow execution

2. **Repository Variables** (Settings → Secrets and variables → Actions → Variables):
   - Add `JAMFPLATFORM_BASE_URL` with your Jamf Platform API endpoint
   - This is visible in the repository but not sensitive

**Note**: The workflows are configured to use these secrets and variables for complete automation support.

## 🗄️ State Management

**⚠️ State Management Warning**

This repository uses **local state files** for simplicity and test/demonstration purposes. The included GitHub workflows use **GitHub Actions caching** for state management, which has significant limitations:

### Local Development

- State files are stored locally in the repository root directory

### GitHub Actions Workflows  

- Uses GitHub Actions cache to persist `terraform.tfstate`
- **Cache may be evicted** without warning
- **Not reliable** for production environments
- **No state locking** - concurrent runs can corrupt state

### Production Usage

**State management is outside the scope of this repository and not discussed.** For production use, always implement correct remote state management (e.g. Terraform Cloud/S3/Azure Blob Storage etc)
