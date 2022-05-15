terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.10"
    }
  }
}

provider "proxmox" {
  pm_api_url          = "https://discovery.homelab.gg:8006/api2/json"
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = true
}

resource "proxmox_vm_qemu" "kube_server" {
  count = 1
  name  = "kube-server-0${count.index + 1}"
  #target_node = "discovery"
  target_node = var.proxmox_host
  #this set the VM ID in Proxmox (for example: "Virtual Machine 100 (test-vm-1) on node 'discovery'"")
  vmid = "40${count.index + 1}"

  clone = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot    = 0
    size    = "10G"
    type    = "scsi"
    storage = "storage"
    #storage_type = "zfspool"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  #used if you have another network interface in proxmox besides vmbr0
  #https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/resources/vm_qemu
  # network {
  #   model  = "virtio"
  #   bridge = "vmbr1"
  # }

  # Ignore changes to the network
  ## MAC address is generated on every apply, causing
  ## TF to think this needs to be rebuilt on every apply
  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.9.5${count.index + 1}/24,gw=${var.default_gw}"
  #   ipconfig1 = "ip=192.168.9.6${count.index + 1}/24"
  #   sshkeys = <<EOF
  #   ${var.ssh_key}
  #   EOF
}

resource "proxmox_vm_qemu" "kube_agent" {
  count       = 2
  name        = "kube-agent-0${count.index + 1}"
  target_node = "discovery"
  vmid        = "50${count.index + 1}"

  clone = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot    = 0
    size    = "10G"
    type    = "scsi"
    storage = "storage"
    #storage_type = "zfspool"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  #   network {
  #     model  = "virtio"
  #     bridge = "vmbr17"
  #   }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.9.10${count.index + 1}/24,gw=${var.default_gw}"
  #   ipconfig1 = "ip=192.168.9.11${count.index + 1}/24"
  #   sshkeys = <<EOF
  #   ${var.ssh_key}
  #   EOF
}

resource "proxmox_vm_qemu" "kube_storage" {
  count       = 1
  name        = "kube-storage-0${count.index + 1}"
  target_node = "discovery"
  vmid        = "60${count.index + 1}"

  clone = var.template_name

  agent    = 1
  os_type  = "cloud-init"
  cores    = 2
  sockets  = 1
  cpu      = "host"
  memory   = 4096
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    slot    = 0
    size    = "20G"
    type    = "scsi"
    storage = "storage"
    #storage_type = "zfspool"
    iothread = 1
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  #   network {
  #     model  = "virtio"
  #     bridge = "vmbr17"
  #   }

  lifecycle {
    ignore_changes = [
      network,
    ]
  }

  ipconfig0 = "ip=192.168.9.15${count.index + 1}/24,gw=${var.default_gw}"
  #   ipconfig1 = "ip=192.168.9.16${count.index + 1}/24"
  #   sshkeys = <<EOF
  #   ${var.ssh_key}
  #   EOF
}