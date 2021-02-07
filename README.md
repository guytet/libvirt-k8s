### libvirt-k8s
#### On the hypervisor
##### Terrafom libvirt provider
1. Obtain the correct terraform libvirt provider for you distro from [terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt/releases)
2. extract the contained file
3. Move the file to its location: 
```
mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.2/linux_amd64
mv mv terraform-provider-libvirt ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.2/linux_amd64
```
##### Bring the cluster up
1. Add your username and ssh key(s) to `cluster.tf`
2. Apply changes with terraform and bring the cluster up:
```
terraform init
terraform apply
```
4. Copy the Makefile to the master node: `scp Makefile node-0:/tmp`
___
<br>

#### On the control/master node
1. Login into the master node and run `make all`: `ssh node-0 ; cd /tmp ; make all `

2. Make note the of the `join` command at the end of `kubeadm join` output, which you'll need to run on all worker nodes:
```

kubeadm join 10.12.35.30:6443 --token fyujbk.508ijhay8hd0iwnu \
   --discovery-token-ca-cert-hash sha256:0b27474ce7eb985a211a85bfd4c50f0985b858c95d44951eacb0dade264a9626
```
<br>

#### On worker node(s)
Copy the `kubeadm join` command from the previous step, login to to the workner nodes and run the command as root.
