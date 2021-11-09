# See install.sh in this dir for the most up to date installation

K8S_DIR="~/.kube"
APISERVER_VIP=10.12.35.55
MASTER0_IP:10.12.35.46
MASTER1_IP:10.12.35.48

# on buster only, containerd available by default on bullseye
containerd:
	curl -fsSL https://download.docker.com/linux/debian/gpg |  apt-key add -
	echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable" | \
        tee /etc/apt/sources.list.d/docker.list

base:
	apt update
	apt -y install make apt-transport-https \
        curl gnupg2 containerd ca-certificates \
        bash-completion

k8s:
	mkdir ${K8S_DIR}
	
	curl -fsSLo \
	/usr/share/keyrings/kubernetes-archive-keyring.gpg \
	https://packages.cloud.google.com/apt/doc/apt-key.gpg
	
	echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] \
	https://apt.kubernetes.io/ kubernetes-xenial main" \
	| tee /etc/apt/sources.list.d/kubernetes.list
	
	apt update
	apt install -y kubelet kubeadm kubectl
	apt-mark hold kubelet kubeadm kubectl
	
	echo 'source <(kubectl completion bash)' >>~/.bashrc
	echo 'source <(kubeadm completion bash)' >>~/.bashrc
	
	mkdir -p /etc/containerd
	containerd config default | tee /etc/containerd/config.toml
	systemctl restart containerd
	

iptables:
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

helm:
	curl -fsSL -o get_helm.sh \
	https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
	
	chmod 700 get_helm.sh
	./get_helm.sh
	rm -f ./get_helm.sh



keepalived:
	apt -y install keepalived
	
	cat <<EOF> /etc/keepalived/keepalived.conf
	! /etc/keepalived/keepalived.conf
	! Configuration File for keepalived
	global_defs {
	    router_id LVS_DEVEL
	}
	vrrp_script check_apiserver {
	  script "/etc/keepalived/check_apiserver.sh"
	  interval 3
	  weight -2
	  fall 10
	  rise 2
	}
	
	vrrp_instance VI_1 {
	    state MASTER
	    interface enp0s3
	    virtual_router_id 151
	    priority 255
	    authentication {
	        auth_type PASS
	        auth_pass P@##D321!
	    }
	    virtual_ipaddress {
	        192.168.1.45/24
	    }
	    track_script {
	        check_apiserver
	    }
	}
	EOF
	
	cat <<EOF> /etc/keepalived/check_apiserver.sh
	#!/bin/sh
	APISERVER_VIP=${API_SERVER_VIP}
	APISERVER_DEST_PORT=6443
	
	errorExit() {
	    echo "*** $*" 1>&2
	    exit 1
	}
	
	curl --silent --max-time 2 --insecure \
	https://localhost:${APISERVER_DEST_PORT}/ -o /dev/null || \
	errorExit "Error GET https://localhost:${APISERVER_DEST_PORT}/"
	
	if ip addr | grep -q ${APISERVER_VIP}; then
	curl --silent --max-time 2 --insecure \
	https://${APISERVER_VIP}:${APISERVER_DEST_PORT}/ -o /dev/null || \
	errorExit "Error GET https://${APISERVER_VIP}:${APISERVER_DEST_PORT}/"
	fi
	EOF
	
	chmod +x /etc/keepalived/check_apiserver.sh

haproxy:
	apt -y install haproxy
	cat <<EOF>> /etc/haproxy/haproxy.cfg
	
	frontend apiserver
	    bind *:8443
	    mode tcp
	    option tcplog
	    default_backend apiserver
		
	backend apiserver
	    option httpchk GET /healthz
	    http-check expect status 200
	    mode tcp
	    option ssl-hello-chk
	    balance     roundrobin
	        server master0 10.12.35.46:6443 check
	        server master1 10.12.35.48:6443 check
	EOF


init_flannel:
	kubeadm init --pod-network-cidr=10.244.0.0/24
	cp -i /etc/kubernetes/admin.conf ${K8S_DIR}/config
	chown -R ${USER}:${USER} ~/.kube

init:
	kubeadm init
	cp -i /etc/kubernetes/admin.conf ${K8S_DIR}/config
	chown -R ${USER}:${USER} ~/.kube

flannel:
	kubectl apply -f \
	https://raw.githubusercontent.com/coreos/flannel/2140ac876ef134e0ed5af15c65e414cf26827915/Documentation/kube-flannel.yml


calico:
	kubectl apply -f https://docs.projectcalico.org/manifests/calico.yaml

clean:
	kubeadm reset --force
	rm -rf  ${K8S_DIR}
