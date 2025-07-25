variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
}

variable "pm_user" {
  description = "Proxmox user with API token"
  type        = string
}

variable "pm_token" {
  description = "Proxmox API token secret"
  type        = string
  sensitive   = true
}

variable "pm_node" {
  description = "Proxmox node name"
  type        = string
}
