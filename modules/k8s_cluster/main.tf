
resource "libvirt_domain" "k8s_node" {
    count     = var.nodecount
    name      = "node-${count.index}"
    memory    = var.ram
    vcpu      = var.vcpu
    autostart = var.autostart
    cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

    network_interface {
        bridge = var.bridge_name
    }

    disk {
        volume_id = libvirt_volume.resized[count.index].id
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

resource "libvirt_volume" "base" {
  count     = var.nodecount
  name      = "node-${count.index}-base.qcow2"
  pool      = var.pool_name
  source    = var.qemu_image_path
  format    = "qcow2"
}

resource "libvirt_volume" "resized" {
  count            =  var.nodecount
  name             =  "node-${count.index}-resized.qcow2"

  base_volume_id   = libvirt_volume.base[count.index].id

  pool             = "default"
  size             = 19084179456  # roughly 16 GB
}


resource "libvirt_cloudinit_disk" "commoninit" {
  count          = var.nodecount
  name           = "cloudinit-node-${count.index}.iso"
  user_data      = templatefile("${path.module}/cloud_init.tpl", {
          user             = var.user_name
          node_name        = "node-${count.index}"
          ssh_keys         = var.ssh_keys
  })
}
