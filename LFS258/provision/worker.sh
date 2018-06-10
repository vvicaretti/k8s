#!/usr/bin/env bash
set -x
set -e

if [ $# -eq 0 ]; then
    exit 1
fi


chmod +x /vagrant/provision/join.sh
bash /vagrant/provision/join.sh

NODE_IP=$1
SYSTEMD_CONFIG="/etc/systemd/system/kubelet.service.d/10-kubeadm.conf"

echo "Environment=\"KUBELET_EXTRA_ARGS=--node-ip=${NODE_IP}\"" >> ${SYSTEMD_CONFIG}

systemctl daemon-reload
systemctl restart kubelet
