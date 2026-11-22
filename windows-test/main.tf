# Phase 1 test VM for the Proxmox gaming host plan
# (dotfiles .claude/plans/2026-11-19-proxmox-gaming-host-windows-11-ltsc.md).
# Disposable Windows 11 IoT LTSC VM on Discovery. No GPU: Phase 5 adds passthrough on the 4U node.
#
# Terraform owns the VM hardware only. Windows itself is installed by hand (or an
# unattended ISO later) and configured by the Boxstarter scripts; snapshots are taken
# with qm or Ansible, not Terraform.

resource "proxmox_virtual_environment_vm" "win11_test" {
  name        = "win11-iot-ltsc-test"
  description = "Phase 1 test VM: Win11 IoT LTSC 24H2 trimmed ISO. Disposable; no real credentials. See dotfiles plan 2026-11-19."
  tags        = ["win11-test"]
  node_name   = var.proxmox_node
  vm_id       = 220

  # Never autostart, and Terraform does not decide whether the VM is running.
  on_boot = false
  started = false

  machine       = "pc-q35-11.0" # Proxmox pins the q35 version when the VM is created
  bios          = "ovmf"
  scsi_hardware = "virtio-scsi-single"
  # Disk first so the "Press any key to boot from CD" prompt does not appear after install.
  boot_order = ["sata0", "ide2"]

  operating_system {
    type = "win11"
  }

  agent {
    enabled = true
    # The agent only exists after virtio-win-guest-tools is installed in Windows, and it can be slow or
    # unreachable while the VM boots or is stopped. Do not let the provider wait its default 15 minutes.
    timeout = "10s"
  }

  cpu {
    sockets = 1
    cores   = 6
    type    = "host"
  }

  memory {
    dedicated = 24576
    floating  = 0
  }

  efi_disk {
    datastore_id      = var.storage_pool
    type              = "4m"
    pre_enrolled_keys = true
  }

  tpm_state {
    datastore_id = var.storage_pool
    version      = "v2.0"
  }

  disk {
    datastore_id = var.storage_pool
    # SATA and e1000 are Windows in-box drivers, so Setup sees the disk and NIC with no driver step.
    interface   = "sata0"
    size        = 100
    file_format = "raw"
    discard     = "on"
    cache       = "writeback"
  }

  cdrom {
    file_id   = "${var.iso_datastore}:iso/${var.windows_iso}"
    interface = "ide2"
  }

  network_device {
    bridge   = "vmbr0"
    model    = "e1000"
    firewall = false
  }

  vga {
    type = "std"
  }

  smbios {
    uuid = var.smbios_uuid
  }

  lifecycle {
    # The ISO is detached after install, and the VM is started and stopped by hand.
    ignore_changes = [started, cdrom]
  }
}
