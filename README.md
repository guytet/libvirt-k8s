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
4. Copy
___

#### On the control/master node
