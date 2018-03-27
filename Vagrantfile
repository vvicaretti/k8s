# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "debian/contrib-stretch64"
  config.vm.hostname = "k8s"
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |vb|
    vb.memory = "2048"
  end
  config.vm.provision "shell", inline: <<-SHELL
    wget http://bit.ly/LFready -O ready-for.sh
    apt-get update
    apt-get install -y vim
  SHELL
end
