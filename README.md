## libvirt-k8s
### Terrafom libvirt provider
1. Obtain the correct terraform libvirt provider for you distro from [terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt/releases)
2. extract the contained file
3. Move the file: 
```
mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.2/linux_amd64
mv mv terraform-provider-libvirt ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.2/linux_amd64
```
