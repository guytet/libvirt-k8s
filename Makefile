
all:  dir init flannel completion

K8S_DIR = ~/.kube

dir:
	mkdir ${K8S_DIR}

init:
	sudo kubeadm init --pod-network-cidr=10.244.0.0/24
	sudo cp -i /etc/kubernetes/admin.conf ${K8S_DIR}/config
	sudo chown -R ${USER}:${USER} ~/.kube

flannel:
	kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml

completion:
	echo 'source <(kubectl completion bash)' >>~/.bashrc
	echo 'source <(kubeadm completion bash)' >>~/.bashrc

clean:
	sudo kubeadm reset --force
	rm -rf  ${K8S_DIR}
