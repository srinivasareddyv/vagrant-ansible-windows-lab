# -*- mode: ruby -*-
# vi: set ft=ruby :

# README
#
# Getting Started:
# 1. vagrant plugin install vagrant-hostmanager
# 2. vagrant up
# 3. vagrant ssh
#
# This should put you at the control host
#  with access, by name, to other vms
Vagrant.configure(2) do |config|
  config.hostmanager.enabled = true

  config.vm.box = "ruanzx/ansible-awx"
#  config.vm.box = "generic/ubuntu2010"
  config.vm.define "awx", primary: true do |h|
    h.vm.hostname =  "awx"
    h.vm.network "private_network", ip: "192.168.136.10"
    h.vm.provision :shell, inline: 'echo demo > /home/vagrant/.vault_pass.txt'
    h.vm.provision "shell" do |provision|
      provision.path = "scripts/linux/provision_ansible.sh"
    end 
    h.vm.provision :shell, :inline => <<'EOF'

	if [ ! -f "/home/vagrant/.ssh/id_rsa" ]; then
  ssh-keygen -t rsa -N "" -f /home/vagrant/.ssh/id_rsa
fi
cp /home/vagrant/.ssh/id_rsa.pub /vagrant/awx.pub

cat << 'SSHEOF' > /home/vagrant/.ssh/config
Host *
  StrictHostKeyChecking no
  UserKnownHostsFile=/dev/null
SSHEOF

chown -R vagrant:vagrant /home/vagrant/.ssh/
EOF
  end

  config.vm.define "dc01" do |h|
    h.vm.box = "gusztavvargadr/windows-server"
    h.vm.hostname = "dc01"
    h.vm.network "private_network", ip: "192.168.136.11"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true

    h.vm.provision "shell", path: "scripts/windows/domain/installAD.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/domain/dcpromo.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-sshd.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 

    h.vm.provider "virtualbox" do |vm|
        vm.gui = false
        vm.cpus = 2
        vm.memory = 2048
    end
  end

  config.vm.define "lb01" do |h|
    h.vm.box = "gusztavvargadr/windows-server"
    h.vm.hostname = "lb01"
    h.vm.network "private_network", ip: "192.168.136.101"
    h.vm.guest = :windows
    h.vm.communicator = "winrm"
    h.vm.boot_timeout = 600
    h.vm.graceful_halt_timeout = 600

    h.vm.network :forwarded_port, guest: 5985, host: 5985, id: "winrm", auto_correct: true
    
    h.vm.provision "shell", path: "scripts/windows/domain/joindomain.ps1", powershell_elevated_interactive: false 
    h.vm.provision "shell", inline: "slmgr /rearm"
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/install-sshd.ps1", powershell_elevated_interactive: false 
    h.vm.provision :reload 
    h.vm.provision "shell", path: "scripts/windows/ConfigureRemotingForAnsible.ps1", powershell_elevated_interactive: false 

    h.vm.provider "virtualbox" do |vm|
        vm.gui = false
        vm.cpus = 2
        vm.memory = 2048
    end
  end
end

