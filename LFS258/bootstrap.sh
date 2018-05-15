export DEBIAN_FRONTEND=noninteractive

cfssl_version="R1.2"

# setup additional repositories:
## sysdig
curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | apt-key add -
curl -s -o /etc/apt/sources.list.d/draios.list https://s3.amazonaws.com/download.draios.com/stable/deb/draios.list
## kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update && apt-get upgrade -y
apt-get install -y \
  apt-transport-https \
  htop \
  linux-headers-"$(uname -r)" \
  kubelet \
  kubeadm \
  kubectl \
  sysdig \
  ca-certificates \
  curl \
  software-properties-common \
  jq \
  docker-ce=17.03.2~ce-0~ubuntu-xenial

curl -sSL \
  -O "https://pkg.cfssl.org/${cfssl_version}/cfssl_linux-amd64" \
  -O "https://pkg.cfssl.org/${cfssl_version}/cfssljson_linux-amd64"

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64

mv -v cfssl_linux-amd64 /usr/local/bin/cfssl
mv -v cfssljson_linux-amd64 /usr/local/bin/cfssljson

# enable auto-completion
{
    echo "source <(kubectl completion bash)"
    echo 'alias kget="kubectl get replicaset,pod,deployment,daemonset -o wide --show-labels"'
    echo 'alias k="kubectl"'

} >> ~/.bashrc

# stern
wget -q -O /usr/bin/stern \
  https://github.com/wercker/stern/releases/download/1.6.0/stern_linux_amd64
chmod +x /usr/bin/stern
