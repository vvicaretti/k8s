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

if $KUBEADM; then
  echo "plugins.cri.systemd_cgroup = true" >> /etc/containerd/config.toml

  kubeadm init --apiserver-advertise-address="${NODE_IP}" --pod-network-cidr "${POD_NETWORK_CIDR}"

  export KUBECONFIG=/etc/kubernetes/admin.conf

  echo "KUBELET_EXTRA_ARGS=\"--node-ip=${NODE_IP}\"" >> ${KUBELET_CONFIG}

  systemctl daemon-reload
  systemctl restart kubelet

  sysctl net.bridge.bridge-nf-call-iptables=1 && cat /proc/sys/net/bridge/bridge-nf-call-iptables
  kubectl apply -f /vagrant/networking/kube-flannel.yml

  chmod 644 /etc/kubernetes/admin.conf

  # Copy kubeconfig
  cp -rf /etc/kubernetes/admin.conf /vagrant/admin.conf

  # Save the join command
  join_command=$(kubeadm token create --print-join-command)
  echo "$join_command" > "${OUTPUT_FILE}"
fi
