# Proxmox Infrastructure as Code (IaC) Project

## Overview

This project demonstrates Infrastructure as Code (IaC) practices using Terraform to automate the deployment and management of virtual machines in a Proxmox Virtual Environment (PVE). This is a practical example of DevOps principles applied to infrastructure management, showcasing automation, version control, and declarative infrastructure configuration.

## Architecture

The project consists of the following components:

```
proxmox-iac/
├── main.tf           # Main Terraform configuration
├── variables.tf      # Variable definitions
├── versions.tf       # Provider and Terraform version constraints
├── terraform.tfvars  # Variable values (contains sensitive data)
└── README.md         # This documentation
```

### Configuration Files Explained

#### `main.tf`

Contains the core Terraform configuration:

- **Provider Configuration**: Sets up the Proxmox provider with authentication
- **Resource Definition**: Defines the Ubuntu VM with specific hardware specifications
- **Network Configuration**: Configures network interfaces and connectivity

#### `variables.tf`

Defines input variables for the configuration:

- `proxmox_url`: The API endpoint for your Proxmox server
- `proxmox_token_id`: Authentication token ID
- `proxmox_token_secret`: Authentication token secret

#### `versions.tf`

Specifies version constraints:

- Terraform version requirement (>= 0.13.0)
- Proxmox provider version (3.0.1-rc9)

#### `terraform.tfvars`

Contains the actual values for the variables (should be kept secure and not committed to version control).

## Prerequisites

Before using this project, ensure you have:

1. **Terraform Installed**: Version 0.13.0 or higher

   ```bash
   # Install Terraform (example for Ubuntu/Debian)
   wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
   echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
   sudo apt update && sudo apt install terraform
   ```

2. **Proxmox Virtual Environment**: A running Proxmox server with:

   - API access enabled
   - A user account with appropriate permissions
   - An API token created for authentication
   - A VM template named "ubuntu" (or modify the clone parameter)

3. **Network Access**: Ability to reach the Proxmox server from your Terraform execution environment

## Setup Instructions

### 1. Proxmox API Token Setup

1. Log into your Proxmox web interface
2. Navigate to Datacenter → Permissions → API Tokens
3. Create a new token for your user (e.g., root@pam)
4. Note down the token ID and secret

### 2. VM Template Preparation

Ensure you have a VM template named "ubuntu" in your Proxmox environment:

1. Create a VM with Ubuntu installed
2. Install qemu-guest-agent
3. Convert the VM to a template

### 3. Configuration

1. Clone or download this repository
2. Copy `terraform.tfvars.example` to `terraform.tfvars` (if provided)
3. Update `terraform.tfvars` with your Proxmox server details:
   ```hcl
   proxmox_url          = "https://your-proxmox-server:8006/api2/json"
   proxmox_token_id     = "your-user@pam!your-token-name"
   proxmox_token_secret = "your-token-secret"
   ```

## Usage

### Initial Setup

```bash
# Initialize Terraform
terraform init

# Verify the configuration
terraform plan
```

### Deploy Infrastructure

```bash
# Apply the configuration
terraform apply

# Confirm the deployment when prompted
```

### Managing Infrastructure

```bash
# View current state
terraform show

# List resources
terraform state list

# Modify configuration and apply changes
terraform plan
terraform apply

# Destroy infrastructure
terraform destroy
```

## VM Configuration Details

The current configuration creates a VM with the following specifications:

- **Name**: vm-devops-1
- **Template**: Ubuntu template
- **Memory**: 2GB RAM
- **CPU**: 2 cores, 1 socket, host CPU type
- **Storage**: 20GB disk on local storage
- **Network**: VirtIO network adapter on vmbr0 bridge
- **Boot**: Enabled (starts automatically with host)

### Customization Options

You can easily modify the VM configuration by editing `main.tf`:

```hcl
resource "proxmox_vm_qemu" "ubuntu_vm" {
  name        = "your-vm-name"
  memory      = 4096  # 4GB RAM
  cpu {
    cores     = 4     # 4 CPU cores
  }
  disk {
    size      = "50G" # 50GB disk
  }
  # ... other configurations
}
```

## Security Considerations

### Sensitive Data Management

- **Never commit `terraform.tfvars`** to version control
- Use environment variables or external secret management
- Consider using Terraform Cloud or similar services for state management

### Network Security

- Ensure Proxmox API is accessible only from trusted networks
- Use HTTPS for API communication
- Regularly rotate API tokens

### Access Control

- Use dedicated API tokens with minimal required permissions
- Regularly review and update access permissions
- Monitor API usage and access logs

## Troubleshooting

### Common Issues

1. **Authentication Errors**

   - Verify API token credentials
   - Check user permissions in Proxmox
   - Ensure API access is enabled

2. **Network Connectivity**

   - Verify Proxmox server is reachable
   - Check firewall settings
   - Confirm API port (8006) is accessible

3. **Template Not Found**

   - Ensure the specified template exists
   - Check template name spelling
   - Verify template is available on the target node

4. **Resource Constraints**
   - Check available storage space
   - Verify CPU and memory availability
   - Review Proxmox resource quotas

### Debug Commands

```bash
# Enable detailed logging
export TF_LOG=DEBUG
export TF_LOG_PATH=terraform.log

# Check Terraform version
terraform version

# Validate configuration
terraform validate

# Refresh state
terraform refresh
```

## Best Practices

### Code Organization

- Use separate `.tf` files for different resource types
- Implement consistent naming conventions
- Add comments to explain complex configurations

### State Management

- Use remote state storage for team environments
- Implement state locking to prevent conflicts
- Regularly backup state files

### Version Control

- Use semantic versioning for releases
- Implement proper branching strategies
- Review changes before merging

### Documentation

- Keep documentation updated with code changes
- Include examples and use cases
- Document any environment-specific requirements

## Extending the Project

### Adding More VMs

Create additional `proxmox_vm_qemu` resources:

```hcl
resource "proxmox_vm_qemu" "web_server" {
  name        = "web-server"
  target_node = "pve"
  clone       = "ubuntu"
  # ... configuration
}

resource "proxmox_vm_qemu" "database_server" {
  name        = "db-server"
  target_node = "pve"
  clone       = "ubuntu"
  # ... configuration
}
```

### Adding Data Sources

Use data sources to reference existing resources:

```hcl
data "proxmox_vm_qemu" "existing_vm" {
  name = "existing-vm-name"
}
```

### Implementing Modules

For larger projects, consider organizing code into modules:

```
modules/
├── vm/
│   ├── main.tf
│   ├── variables.tf
│   └── outputs.tf
└── network/
    ├── main.tf
    ├── variables.tf
    └── outputs.tf
```

## Contributing

When contributing to this project:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request with detailed description

## License

This project is provided as-is for educational and demonstration purposes. Please ensure compliance with your organization's policies and Proxmox licensing requirements.

## Support

For issues related to:

- **Terraform**: Check the [Terraform documentation](https://www.terraform.io/docs)
- **Proxmox Provider**: Visit the [provider repository](https://github.com/Telmate/terraform-provider-proxmox)
- **Proxmox VE**: Consult the [Proxmox documentation](https://pve.proxmox.com/wiki/Main_Page)

---

**Note**: This project demonstrates DevOps practices and Infrastructure as Code concepts. Always test in a safe environment before applying to production systems.
