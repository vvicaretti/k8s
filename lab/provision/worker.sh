#!/usr/bin/env bash
set -x
set -e

if [ $# -eq 0 ]; then
    exit 1
fi

apt-get update && apt-get install nfs-common

if $KUBEADM; then
  echo "plugins.cri.systemd_cgroup = true" >> /etc/containerd/config.toml

  chmod +x /vagrant/provision/join.sh
  bash /vagrant/provision/join.sh

  NODE_IP=$1
  KUBELET_CONFIG="/etc/default/kubelet"

  echo "KUBELET_EXTRA_ARGS=\"--node-ip=${NODE_IP}\"" > ${KUBELET_CONFIG}

  systemctl daemon-reload
  systemctl restart kubelet
fi
