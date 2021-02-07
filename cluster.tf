
module k8s_cluster {
  source = "./modules/k8s_cluster"
  user_name = ""
  ssh_keys = [
    "ssh-ed25519 ...AAAAC3NzaC1lZ... user@host ",
    "ssh-ed25519 ...AAAAC3NzaC1lZ... user@host"]
  ram = "2048"
  vcpu = "4"
  bridge_name =""

  # Optional:
  # Provide a path to a local cloud image, to avoid fetching image from the web
  qemu_image_path = ""
}
