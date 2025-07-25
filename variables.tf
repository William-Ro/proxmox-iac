variable "proxmox_url" {
  type        = string
}

variable "proxmox_token_id" {
  type        = string
  sensitive   = true
}

variable "proxmox_token_secret" {
  type        = string
  sensitive   = true
}

