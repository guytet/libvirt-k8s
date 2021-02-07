
variable "names" {
  type = "list"
  default = ["k8s-master", "node"]
}

variable "nodecount" {
  default = 1
}


variable "user_name" {
  description =  "The default username on the linux VM"
  default = ""
}

variable "ssh_keys" {
  description = "List of ssh keys to add to default user's authorized_keys"
  type = list
  default = []
}

variable "ram" {
  default = "2048"
}

variable "vcpu" {
  default = "2"
}

variable "autostart" {
  description = "Whether the VM should autostart when libvirt starts"
  type    = bool
  default = false
}


variable "bridge_name" {
  description = "assuming bridge as the preferred networking model for your VM, name of the host's bridge to bind to"
  default = "br0"
}

variable "qemu_image_path" {
  description = "path or URL for qemu image"
  default = "http://cloud-images.ubuntu.com/releases/bionic/release-20191008/ubuntu-18.04-server-cloudimg-amd64.img"
}

variable "pool_name" {
  description = "qemu storage pool name"
  default = "default"
}

variable "node_ram" {
  default = "2048"
}
