provider "proxmox" {
  pm_api_url      = var.pm_api_url
  pm_user         = var.pm_user
  pm_api_token    = var.pm_token
  pm_tls_insecure = true
}

resource "proxmox_vm_qemu" "ubuntu_vm" {
  name        = "vm-devops-1"
  target_node = var.pm_node
  clone       = "ubuntu" # Ensure this template exists
  full_clone  = true

  os_type     = "cloud-init" # Use cloud-init for easier configuration

  cores       = 2
  sockets     = 1
  memory      = 2048
  scsihw      = "virtio-scsi-pci"
  boot        = "cdn"
  bootdisk    = "scsi0"

  disk {
    slot     = 0
    size     = "10G"
    type     = "scsi"
    storage  = "local-lvm"
    iothread = true
  }

  network {
    model = "virtio"
    bridge = "vmbr0"
  }
  ipconfig0 = "ip=dhcp"

  ciuser     = "ubuntu"
  cipassword = "changeme" 

  # Autoencendido
  onboot = true
}

