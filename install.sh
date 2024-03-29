
# on buster only, containerd available by default on bullseye
curl -fsSL https://download.docker.com/linux/debian/gpg |  apt-key add -
echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" | tee /etc/apt/sources.list.d/docker.list

# base packages
apt -y install make apt-transport-https \
curl gnupg2 containerd ca-certificates \
bash-completion

# k8s keys
curl -fsSLo \
/usr/share/keyrings/kubernetes-archive-keyring.gpg \
https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] \
 https://apt.kubernetes.io/ kubernetes-xenial main" \
| tee /etc/apt/sources.list.d/kubernetes.list

# k8s packages
apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# iptables
cat  <<eof> /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
net.bridge.bridge-nf-call-iptables  = 1
eof

cat <<eof> /etc/modules-load.d/modules.conf
overlay
br_netfilter
eof

sysctl --system
modprobe br_netfilter

# bash completion
echo 'source <(kubectl completion bash)' >>~/.bashrc
echo 'source <(kubeadm completion bash)' >>~/.bashrc

# helm
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm -f ./get_helm.sh

# containerd config (if it's the runtime)
mkdir -p /etc/containerd
containerd config default | tee /etc/containerd/config.toml
systemctl restart containerd

# on master
mkdir ~/.kube
cp /etc/kubernetes/admin.conf /root/.kube/

# calico CNI
kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

# done, confirm:
kubectl get nodes
kubectl config view

# test deployment
kubectl apply -f ngnix.yml

kubectl get svc my-nginx # note the port the service is forwarded to

kubectl get pods -o wide my-nginx-5b56ccd65f-5bvkn # note the worker node the pod is running on

curl worker0:30908 # then, curl the resulting address:

# In our case, being  we're exposing the service with external IP's, the curl command would work from 
# other clients on the LAN, with the master's IP in the curl command, e.g curl master0:8080

