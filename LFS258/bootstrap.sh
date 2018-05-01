# upgrade
export DEBIAN_FRONTEND=noninteractive

# setup additional repositories:
## sysdig
curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | apt-key add -
curl -s -o /etc/apt/sources.list.d/draios.list https://s3.amazonaws.com/download.draios.com/stable/deb/draios.list
## kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list

apt-get update && apt-get upgrade -y
apt-get install -y \
  apt-transport-https \
  htop \
  linux-headers-"$(uname -r)" \
  kubelet=1.9.1-00 \
  kubeadm=1.9.1-00 \
  kubectl \
  sysdig \
  jq

# enable auto-completion
echo "source <(kubectl completion bash)" >> ~/.bashrc

# stern
wget -q -O /usr/bin/stern \
  https://github.com/wercker/stern/releases/download/1.6.0/stern_linux_amd64
chmod +x /usr/bin/stern
