#!/usr/bin/env bash
set -x
set -e

if [ $# -eq 0 ]; then
    exit 1
fi

POD_NETWORK_CIDR=$1
NODE_IP=$2
OUTPUT_FILE="/vagrant/provision/join.sh"
KUBELET_CONFIG="/etc/default/kubelet"

kubeadm init --apiserver-advertise-address="${NODE_IP}" --pod-network-cidr "${POD_NETWORK_CIDR}" | grep "kubeadm join" > "${OUTPUT_FILE}"

export KUBECONFIG=/etc/kubernetes/admin.conf

echo "KUBELET_EXTRA_ARGS=\"--node-ip=${NODE_IP}\"" >> ${KUBELET_CONFIG}

systemctl daemon-reload
systemctl restart kubelet

kubectl apply -f /vagrant/networking/kube-flannel.yml

chmod 644 /etc/kubernetes/admin.conf

# https://itnext.io/understanding-kubectl-taint-e6f299d3851f
kubectl taint nodes --all node-role.kubernetes.io/master-

# get k8s config
echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> /home/vagrant/.bashrc
