export DEBIAN_FRONTEND=noninteractive

CFSSL_VERSION="R1.2"
KUBERNETES_VERSION="1.11.2-00"
DOCKER_VERSION="17.03.2~ce-0~ubuntu-xenial"

# setup additional repositories:
## sysdig
curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | apt-key add -
curl -s -o /etc/apt/sources.list.d/draios.list https://s3.amazonaws.com/download.draios.com/stable/deb/draios.list
## kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
## golang
add-apt-repository ppa:gophers/archive

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update && apt-get upgrade -y
apt-get install -y \
  --allow-change-held-packages \
  apt-transport-https \
  htop \
  ngrep \
  lynx \
  socat \
  conntrack \
  ipset \
  linux-headers-"$(uname -r)" \
  kubelet=${KUBERNETES_VERSION} \
  kubeadm=${KUBERNETES_VERSION} \
  kubectl=${KUBERNETES_VERSION} \
  sysdig \
  ca-certificates \
  golang-1.10-go \
  curl \
  software-properties-common \
  jq \
  nfs-kernel-server \
  docker-ce=${DOCKER_VERSION}

apt-mark hold kubelet kubeadm kubectl docker-ce

# setup nfs
mkdir -p /opt/data && chmod 1777 /opt/data/ && echo software > /opt/data/hello.txt
echo "/opt/data/ *(rw,sync,no_root_squash,subtree_check)" >> /etc/exports
exportfs -ra

curl -sSL \
  -O "https://pkg.cfssl.org/${CFSSL_VERSION}/cfssl_linux-amd64" \
  -O "https://pkg.cfssl.org/${CFSSL_VERSION}/cfssljson_linux-amd64"

chmod +x cfssl_linux-amd64 cfssljson_linux-amd64

mv -v cfssl_linux-amd64 /usr/local/bin/cfssl
mv -v cfssljson_linux-amd64 /usr/local/bin/cfssljson

# enable auto-completion
{
    echo "source <(kubectl completion bash)"
    echo 'alias kget="kubectl get replicaset,pod,deployment,daemonset -o wide --show-labels"'
    echo 'alias k="kubectl"'
    echo 'export KUBECONFIG=/etc/kubernetes/admin.conf'
    echo "export PATH=/usr/lib/go-1.10/bin:$PATH"

} >> /home/vagrant/.bashrc

# stern
wget -q -O /usr/bin/stern \
  https://github.com/wercker/stern/releases/download/1.6.0/stern_linux_amd64
chmod +x /usr/bin/stern
