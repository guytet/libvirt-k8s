### libvirt-k8s
#### On the hypervisor
##### Terrafom libvirt provider
1. Obtain the correct terraform libvirt provider for your distro from [terraform-provider-libvirt](https://github.com/dmacvicar/terraform-provider-libvirt/releases)
2. extract the contained file
3. Move the file to its location: 
```
mkdir -p ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.2/linux_amd64
mv terraform-provider-libvirt ~/.local/share/terraform/plugins/registry.terraform.io/dmacvicar/libvirt/0.6.2/linux_amd64
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
1. Login to the master node and run `make all`: `ssh node-0 ; cd /tmp ; make all `

2. Make note the of the `join` command at the end of `kubeadm join` output, which you'll need to run on all worker nodes:
```

kubeadm join 10.12.35.30:6443 --token fyujbk.508ijhay8hd0iwnu \
   --discovery-token-ca-cert-hash sha256:0b27474ce7eb985a211a85bfd4c50f0985b858c95d44951eacb0dade264a9626
```
<br>

#### On worker node(s)
Copy the `kubeadm join` command from the previous step, login to to the worker nodes and run the command as root.
___

<br>

#### Back to the master, confirm cluster is ready for work:
```
kubectl cluster-info
kubectl get nodes
```
```
user@node-0:/tmp$ kubectl cluster-info 
Kubernetes control plane is running at https://10.12.35.30:6443
KubeDNS is running at https://10.12.35.30:6443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy

To further debug and diagnose cluster problems, use 'kubectl cluster-info dump'.
```
```
user@node-0:/tmp$ kubectl get nodes 
NAME     STATUS   ROLES                  AGE     VERSION
node-0   Ready    control-plane,master   9m47s   v1.20.2
```

In order to bring back the cluster to its inital pre-configuration state, on the master node:
```
make clean
```
