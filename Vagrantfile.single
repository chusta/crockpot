# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

HOSTS = {
  "base"   => "192.168.255.100"
}

def shell_script(hosts)
  cmd = []
  hosts.each do |name, ip|
    cmd << "[ $(fgrep -c '#{ip}') -eq 0 ] && echo '#{ip} #{name}' >> /etc/hosts"
  end
  cmd << "apt-get -y install aptitude python"
  cmd.join(";")
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/xenial64"
  config.vm.communicator = "ssh"
  config.ssh.username = "ubuntu"
  config.ssh.insert_key = true

  config.vm.provider "virtualbox" do |vb|
    vb.memory = "4096"
    vb.cpus = "1"
    vb.gui = false
  end

  config.vm.provision "shell", inline: shell_script(HOSTS)

  config.vm.define "base" do |hpot|
    base.vm.network "private_network", ip: HOSTS["base"]

    base.vm.network "forwarded_port", guest: 21,   host: 10021  # dionaea-ftp
    base.vm.network "forwarded_port", guest: 80,   host: 10080  # glastopf-http
    base.vm.network "forwarded_port", guest: 135,  host: 10135  # dionaea-epmap
    base.vm.network "forwarded_port", guest: 445,  host: 10445  # dionaea-smb
    base.vm.network "forwarded_port", guest: 1234, host: 11234  # honeytrap-tcp
    base.vm.network "forwarded_port", guest: 1433, host: 11433  # dionaea-mssql
    base.vm.network "forwarded_port", guest: 2222, host: 10022  # cowrie-ssh
    base.vm.network "forwarded_port", guest: 2323, host: 10023  # cowrie-telnet
    base.vm.network "forwarded_port", guest: 3306, host: 13306  # dionaea-mysql
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "crockpot.yml"
    ansible.limit = "all"
    ansible.verbose = false
    ansible.sudo = true

    ansible.extra_vars = {
      "ansible_user" => config.ssh.username,
      "is_vagrant"   => true
    }
    ansible.groups = {
        "collector" => [ "base" ],
        "honeypot"  => [ "base" ]
    }
  end

  config.vm.synced_folder ".", "/vagrant"

end
