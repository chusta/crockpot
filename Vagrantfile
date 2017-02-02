# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.communicator = "ssh"
  config.ssh.username = "ubuntu"
  config.ssh.insert_key = true

  config.vm.network "forwarded_port", guest: 21, host: 60021   # dionaea-ftp
  config.vm.network "forwarded_port", guest: 22, host: 60022   # cowrie-ssh
  config.vm.network "forwarded_port", guest: 23, host: 60023   # cowrie-telnet
  config.vm.network "forwarded_port", guest: 135, host: 60135   # dionaea-epmap
  config.vm.network "forwarded_port", guest: 445, host: 60445   # dionaea-smb
  config.vm.network "forwarded_port", guest: 1433, host: 61433   # dionaea-mssql
  config.vm.network "forwarded_port", guest: 3306, host: 63306   # dionaea-mysql

  config.vm.provider "virtualbox" do |vb|
    vb.name = "crockpot"
    vb.memory = "4096"
    vb.cpus = "2"
    vb.gui = false
  end

  config.vm.provision "shell",
    inline: "sudo apt-get -y install aptitude python"

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "vagrant.yml"
    ansible.verbose = false
    ansible.sudo = true
  end

  config.vm.synced_folder ".", "/vagrant"
end
