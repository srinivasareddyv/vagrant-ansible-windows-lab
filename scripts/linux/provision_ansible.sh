#!/bin/bash
echo "Starting provisioning of Ansible..."

sudo  sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd
#sudo yum update -y
sudo yum install -y git wget vim centos-release-ansible-29.noarch epel-release 
sudo yum install -y ansible python-pip  python-pip3 gcc python36-devel krb5-devel krb5-workstation openssl-devel rust cargo
sudo pip3 install setuptools_rust
sudo pip3 install wheel
#sudo pip3 install "pywinrm>=0.2.2"
sudo pip3 install pywinrm

sudo ansible-galaxy install deekayen.win_updates
sudo ansible-galaxy install mrlesmithjr.windows-iis
