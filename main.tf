provider "proxmox" {
  pm_api_url= var.proxmox_url
  pm_api_token_id = var.proxmox_token_id
  pm_api_token_secret = var.proxmox_token_secret
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "ubuntu_vm" {
  # General Settings
  name        = "vm-devops-1"
  desc        = "description"
  agent       = 1

  target_node = "pve"

  clone       = "ubuntu" # Ensure this template exists
  full_clone  = true

  onboot      = true

  # VM Configuration

  memory      = 2048

  cpu {
    type      = "host"
    sockets   = 1
    cores     = 2
  }
  disk {
    slot      = "scsi0"
    size      = "20G"
    storage   = "local"
    iothread  = true
    replicate = false
  }
  network {
    id        = 0
    model     = "virtio"
    bridge    = "vmbr0"
  }
 
}


