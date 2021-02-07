## template: jinja
#cloud-config
# vim: syntax=yaml

users:
  - name: ${user} 
    primary_group: ${user}
    groups: [adm, cdrom, dialout, plugdev, dip, netdev, sudo]
    ssh_authorized_keys:
        %{ for item in ssh_keys }
        - ${item}
        %{ endfor }
    sudo: ALL=(ALL) NOPASSWD:ALL
    home: /home/${user}
    shell: /bin/bash


growpart:
  mode: auto
  devices: ['/']


write_files:
  - path: /etc/sysctl.d/k8.conf
    content: |
      net.bridge.bridge-nf-call-ip6tables = 1
      net.ipv4.ip_forward                 = 1
      net.bridge.bridge-nf-call-iptables  = 1

  - path: /etc/modules-load.d/modules.conf
    content: |
      overlay
      br_netfilter

apt:
  sources:
    k8s.list:
      source: "deb https://apt.kubernetes.io/ kubernetes-xenial main"
      keyid: "54A647F9048D5688D7DA2ABE6A030B21BA07F4FB"


packages:
  - apt-transport-https
  - curl
  - gnupg2
  - containerd
  - kubelet
  - kubeadm
  - kubectl
apt_update: True


runcmd:
  - apt-mark hold kubelet kubeadm kubectl
  - sysctl --system
  - modprobe br_netfilter
  - hostnamectl set-hostname ${node_name}


power_state:
  delay: "now"
  mode: reboot
  message: "Cloudinit done, rebooting as stated in cloud_init.cfg powerstate"
  timeout: 5
  condition: True
