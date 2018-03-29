# upgrade
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get upgrade -y
# install requirements
apt-get install -y apt-transport-https
# setup k8s repository
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
apt-get update
# install k8s components/utils
apt-get install -y kubelet kubeadm kubectl
# download flannel
wget -q -O kube-flannel.yml \
    https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
