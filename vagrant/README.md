# Explicando virtualização com o auxílio do Vagrant

## Descrição dos arquivos

Vários arquivos com cenários distintos que serão explicados ao longo desta página.

A maioria destes exemplos de configuração foi retirada do próprio site do [Vagrant](https://vagrantup.com).

## Instalação do Virtualbox e do Vagrant

```markdown
$ sudo apt update
...
$ sudo apt -y install virtualbox
...
$ sudo apt -y install vagrant
...
```

## Iniciando com o Vagrant

```markdown
$ vagrant init ubuntu/bionic64
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
$
```

### Vagrantfile original (Vagrantfile.original)
```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  config.vm.box = "ubuntu/bionic64"

...
end
```

## Cenário com múltiplas VMs

### Introdutório (Vagrantfile.multimachines1.intro)

```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.provision "shell", inline: "echo Aloh mundo!!!"

  config.vm.define "vm1" do |vm1|
    vm1.vm.box = "ubuntu/bionic64"
  end

  config.vm.define "vm2" do |vm2|
    vm2.vm.box = "centos/7"
  end
end
```

### A ordem é importante (Vagrantfile.multimachines2.orderingtest)

```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"
  config.vm.provision :shell, inline: "echo A"

  config.vm.define "vm1" do |vm1|
    vm1.vm.provision :shell, inline: "echo B"
  end

#  config.vm.define "vm2" do |vm2|
#    vm2.vm.provision :shell, inline: "echo C"
#  end

  config.vm.provision :shell, inline: "echo D"
end
```

### Não levantar VM automaticamente (Vagrantfile.multimachines3.autostart)

```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"

  config.vm.define "vm1"

  config.vm.define "vm2"

  config.vm.define "vm3", autostart: false

end
```

### Criar várias VMs com loop (Vagrantfile.multimachines4.loop)

```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  (1..3).each do |i|
    config.vm.define "vm#{i}" do |vms|
      vms.vm.provision "shell", inline: "echo Aloh mundo da vm #{i}"
    end
  end

end
```

## Cenários com configurações de rede

### Cenário introdutório (Vagrantfile.network1.intro)

```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.network "public_network"

end
```

### Criar máquinas em rede com loop (Vagrantfile.network2.loop)

```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/bionic64"

  (1..3).each do |i|
    config.vm.define "vm#{i}" do |vms|
      vms.vm.provision "shell", inline: "echo Aloh mundo da vm #{i}"
      vms.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
        vb.cpus = "1"
      end
      vms.vm.hostname = "vm#{i}"
      vms.vm.network "public_network", bridge: "eno1"
      vms.vm.network "private_network", ip: "192.168.1.#{i}"
    end
  end

end
```

### Criar máquinas em rede com definição de "cluster" (Vagrantfile.network3.cluster)

```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

cluster = {
  "master" => { :ip => "192.168.33.10", :cpus => 1, :mem => 512},
  "slave" => { :ip => "192.168.33.11", :cpus => 1, :mem => 512}
}

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "ubuntu/bionic64"

  cluster.each_with_index do |(hostname, info), index|

    config.vm.define hostname do |cfg|

      cfg.vm.provider :virtualbox do |vb, override|

        override.vm.network :private_network, ip: "#{info[:ip]}"
        override.vm.hostname = hostname
        vb.name = hostname
        vb.customize ["modifyvm", :id, "--memory", info[:mem], "--cpus", info[:cpus], "--hwvirtex", "on"]

      end # end provider

    end # end define

  end # end cluster

end # end config
```

### Cenário de geração de tráfego (Vagrantfile.network4.trafficgen)

```markdown
# -*- mode: ruby -*-
# vi: set ft=ruby :

NODES = [
    { :hostname => "node1", :ip => "192.168.0.11" },
    { :hostname => "node2", :ip => "192.168.0.12" },
    { :hostname => "controller", :ip => "192.168.0.2" }
]

Vagrant.configure("2") do |config|

  # Do whatever global config here
  config.vm.box = "ubuntu/bionic64"

  NODES.each do |node|

    config.vm.define node[:hostname] do |nodeconfig|

      # Do config that is the same across each node
      nodeconfig.vm.hostname = node[:hostname]
      nodeconfig.vm.network "public_network", bridge: "eno1"
      nodeconfig.vm.network "private_network", ip: node[:ip]
      nodeconfig.vm.provision "shell", inline: <<-SHELL
        echo -e "\n192.168.0.2 controller\n192.168.0.11 node1\n192.168.0.12 node2" | sudo tee -a /etc/hosts
      SHELL

      if node[:hostname] == "controller"
        # Do your provisioning for this machine here
        nodeconfig.vm.provision "shell", inline: <<-SHELL
	  echo "Controller"
          echo "git cloning slice-enablers.git"
          git clone https://github.com/dcomp-leris/slice-enablers.git --quiet
          chown -R vagrant.vagrant slice-enablers

          echo "apt install iperf"
          bash slice-enablers/scripts/apt.sh

          echo "iniciando servidor iperf"
          bash slice-enablers/scripts/servidor-iperf.sh
        SHELL

      else
        # Do provisioning for the other machines here
        nodeconfig.vm.provision "shell", inline: <<-SHELL
	  echo "Node"
          echo "git cloning slice-enablers.git"
          git clone https://github.com/dcomp-leris/slice-enablers.git --quiet
          chown -R vagrant.vagrant slice-enablers

          echo "apt install iperf"
          bash slice-enablers/scripts/apt.sh
        SHELL

      end

    end

  end
  # Do any global provisioning

end
```
