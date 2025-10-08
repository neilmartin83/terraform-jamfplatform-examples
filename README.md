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
   # Edit terraform.tfvars with your actual values
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

This repository uses local `terraform.tfvars` file for authentication. You need to create your own `terraform.tfvars` file with your credentials.

**Required Variables:**

Create a `terraform.tfvars` file in the root directory:

```hcl
# Jamf Platform API Configuration
jamfplatform_base_url     = "https://us.apigw.jamf.com"  # or eu/apac
jamfplatform_client_id    = "your-jamfplatform-client-id"
jamfplatform_client_secret= "your-jamfplatform-client-secret"

# Jamf Pro API Configuration (for group management)
jamfpro_instance_fqdn     = "https://yourcompany.jamfcloud.com"
jamfpro_auth_method       = "oauth2"  # or "basic"
jamfpro_client_id         = "your-jamfpro-client-id"
jamfpro_client_secret     = "your-jamfpro-client-secret"
```

**⚠️ Security Note**: Never commit `terraform.tfvars` to version control. It's already included in `.gitignore`.

### Dual Provider Architecture

This repository demonstrates using both providers together:

- **`jamfplatform` provider** - For compliance benchmarks, blueprints, and platform-level resources
- **`jamfpro` provider** - For creating and managing Jamf Pro groups, then sourcing their Platform IDs

### Group Platform ID Sourcing

The `main.tf` shows how to create a Jamf Pro group and automatically get its Platform ID:

```hcl
# Create a group in Jamf Pro
resource "jamfpro_smart_computer_group" "demo_target_group" {
  name = "Jamf Platform Demo Target Group"
}

# Get the Platform ID for use with jamfplatform resources
data "jamfpro_group" "demo_target_group" {
  group_jamfpro_id = jamfpro_smart_computer_group.demo_target_group.id
  group_type       = "COMPUTER"
}

# Use the Platform ID in jamfplatform resources
resource "jamfplatform_cbengine_benchmark" "example" {
  # ... other configuration ...
  target_device_groups = [data.jamfpro_group.demo_target_group.group_platform_id]
}
```

## � Repository Structure

```
terraform-jamfplatform-examples/
├── main.tf                    # Main configuration for you to edit as required
├── provider.tf               # Provider configurations for both jamfplatform and jamfpro
├── variables.tf              # Variable definitions
├── terraform.tfvars         # Your local variable configuration (not in git)
├── examples/
│   ├── data_sources/
│   │   └── benchmarks/
│   │       └── all_baselines_all_rules.tf  # Export all benchmarks to CSV
│   └── resources/
│       └── (resource examples)
└── README.md
```

## 📊 Current Examples

### Data Sources

- **All Baselines and Rules** (`examples/data_sources/benchmarks/all_baselines_all_rules.tf`)
  - Fetches all available compliance baselines and their rules
  - Exports comprehensive data to CSV format including ODV fields
  - Demonstrates `jamfplatform_cbengine_baselines` and `jamfplatform_cbengine_rules` data sources

### Main Configuration

The root `main.tf` includes:

- **Dual Provider Setup** - Shows how to configure both `jamfplatform` and `jamfpro` providers
- **Smart Computer Group Creation** - Creates a demo target group in Jamf Pro
- **Platform ID Resolution** - Uses the `jamfpro_group` data source to get the Platform ID

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
   
   jamfpro_instance_fqdn      = "https://yourcompany.jamfcloud.com"
   jamfpro_auth_method        = "oauth2"
   jamfpro_client_id          = "your-jamfpro-client-id"
   jamfpro_client_secret      = "your-jamfpro-client-secret"
   ```

3. **Initialize and run**

   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

### What the Example Does

The main configuration will:

- Create a smart computer group in Jamf Pro called "Jamf Platform Demo Target Group"
- Resolve the group's Platform ID using the `jamfpro_group` data source
- Create resources and read from any data sources you've added and adjusted from the examples

### Extending the Configuration

Add your own resources to `main.tf` below the comment line:

```hcl
# Add data source and resource blocks below this line as required

# Your custom resources here
resource "jamfplatform_cbengine_benchmark" "my_benchmark" {
  # Configuration...
}
```

## � Provider Documentation

This repository uses two Terraform providers:

### Jamf Platform Provider (`Jamf-Concepts/jamfplatform`)

- **Purpose**: Manage Jamf Platform resources like compliance benchmarks and blueprints
- **Version**: 0.1.2
- **Authentication**: OAuth2 client credentials
- **Documentation**: [Terraform Registry](https://registry.terraform.io/providers/Jamf-Concepts/jamfplatform/latest/docs)

**Key Resources:**

- `jamfplatform_cbengine_benchmark` - Compliance benchmarks
- `jamfplatform_blueprints_blueprint` - Device management blueprints

**Key Data Sources:**

- `jamfplatform_cbengine_baselines` - Available compliance baselines
- `jamfplatform_cbengine_rules` - Rules for specific baselines

### Jamf Pro Provider (`deploymenttheory/jamfpro`)

- **Purpose**: Manage traditional Jamf Classic and Pro API resources like computer groups, policies, etc.
- **Version**: 0.26.0  
- **Authentication**: OAuth2 client credentials
- **Documentation**: [Terraform Registry](https://registry.terraform.io/providers/deploymenttheory/jamfpro/latest/docs)

**Key Resources:**

- `jamfpro_smart_computer_group` - Smart computer groups

**Key Data Sources:**

- `jamfpro_group` - Group information including Platform ID resolution

## 🔄 Platform ID Resolution

A key feature demonstrated in this repository is how to bridge between Jamf Pro and Jamf Platform resources:

1. **Create a group in Jamf Pro** using the `jamfpro` provider
2. **Get the Platform ID** using the `jamfpro_group` data source
3. **Use the Platform ID** in `jamfplatform` resources for targeting

This pattern is essential because Jamf Platform resources reference groups by their Platform UUID, not their traditional Jamf Pro ID.

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
- `jamfpro_client_id` - Your Jamf Pro API client ID
- `jamfpro_client_secret` - Your Jamf Pro API client secret

### Required Repository Variables

Configure these repository variables for non-sensitive configuration values:

- `JAMFPLATFORM_BASE_URL` - Your Jamf Platform API base URL (e.g., `https://us.apigw.jamf.com`)
- `JAMFPRO_INSTANCE_FQDN` - Your Jamf Pro instance FQDN (e.g., `https://yourcompany.jamfcloud.com`)
- `JAMFPRO_AUTH_METHOD` - Authentication method for Jamf Pro (e.g., `oauth2`)

### Setting Up GitHub Repository Configuration

1. **Repository Secrets** (Settings → Secrets and variables → Actions → Secrets):
   - Add each secret with its corresponding API credential value
   - These are encrypted and only available during workflow execution

2. **Repository Variables** (Settings → Secrets and variables → Actions → Variables):
   - Add each variable with its corresponding configuration value
   - These are visible in the repository but not sensitive

**Note**: The workflows are configured to use all secrets and variables listed above, providing complete automation support for both Jamf Platform and Jamf Pro resources.

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
