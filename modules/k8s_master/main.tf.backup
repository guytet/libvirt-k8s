
resource "libvirt_domain" "k8s_master" {
    name   = var.master_name
    memory = var.ram
    vcpu   = var.vcpu
    autostart = var.autostart
    cloudinit = libvirt_cloudinit_disk.commoninit-master.id

    network_interface {
        bridge = var.bridge_name
    }

    disk {
        volume_id = libvirt_volume.master-resized.id
    }

  console {
    type = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type = "spice"
    listen_type = "address"
    autoport = true
  }

}

resource "libvirt_volume" "master-base" {
  name = "${var.master_name}.qcow2"
  pool = var.pool_name
  source = var.qemu_image_path
  format = "qcow2"
}

resource "libvirt_volume" "master-resized" {
  name           = "${var.master_name}-resized.qcow2"
  base_volume_id = libvirt_volume.master-base.id
  pool           = "default"
  size           = 19084179456  # roughly 16 GB
}


locals {
  user_data = templatefile("${path.module}/cloud_init.tpl", {
          user             = var.user_name
          master_name      = var.master_name
          ssh_keys         = var.ssh_keys
         })
}


resource "libvirt_cloudinit_disk" "commoninit-master" {
  name           = "commoninit-${var.master_name}.iso"
  user_data      = local.user_data
}
