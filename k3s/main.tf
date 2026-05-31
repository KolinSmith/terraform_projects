locals {
  vms = {
    control = {
      vmid    = 200
      name    = "k3s-control-01"
      ip      = "192.168.9.20"
      cores   = 2
      memory  = 4096
      disk_gb = 20
    }
    worker01 = {
      vmid    = 201
      name    = "k3s-worker-01"
      ip      = "192.168.9.21"
      cores   = 2
      memory  = 6144
      disk_gb = 40
    }
    worker02 = {
      vmid    = 202
      name    = "k3s-worker-02"
      ip      = "192.168.9.22"
      cores   = 2
      memory  = 6144
      disk_gb = 40
    }
  }
}

resource "proxmox_virtual_environment_vm" "k3s" {
  for_each  = local.vms
  name      = each.value.name
  node_name = var.proxmox_node
  vm_id     = each.value.vmid

  clone {
    vm_id = var.template_vm_id
    full  = true
  }

  agent {
    enabled = true
  }

  cpu {
    cores = each.value.cores
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = each.value.memory
  }

  disk {
    datastore_id = var.storage_pool
    size         = each.value.disk_gb
    interface    = "scsi0"
    file_format  = "raw"
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "192.168.9.1"
      }
    }
    user_account {
      username = "dax"
      keys     = [var.ssh_public_key]
    }
  }

  lifecycle {
    ignore_changes = [initialization]
  }
}
