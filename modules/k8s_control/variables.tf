
variable "master_name" {
  default = ""
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
  default = ""
}

variable "vcpu" {
  default = ""
}

variable "autostart" {
  description = "Whether VM should autostart on hosts powerup"
  type    = bool
  default = false
}


variable "bridge_name" {
  description = "assuming bridge, name of hosts bridge name to bind to"
  default = ""
}

variable "qemu_image_path" {
  description = "path or URl for qemu image"
  default = "http://cloud-images.ubuntu.com/releases/bionic/release-20191008/ubuntu-18.04-server-cloudimg-amd64.img"
}

variable "pool_name" {
  description = "qemu storage pool name"
  default = "default"
}
