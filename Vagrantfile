require "yaml"
settings = YAML.load_file "config.yaml"
cluster_name = settings['cluster-name']

Vagrant.configure("2") do |config|
  config.vm.box = settings['box']
  config.vm.box_check_update = false
  config.vm.synced_folder ".", "/vagrant", create: true

  config.vm.provider "virtualbox" do |vb|
    vb.linked_clone = true
    vb.customize ["modifyvm", :id, "--graphicscontroller", "vmsvga"]
    vb.customize ["modifyvm", :id, "--groups", ("/" + cluster_name)]
    vb.cpus = "2"
    vb.memory = "1024"
  end

  config.vm.provision "shell", inline: <<-SHELL
      sudo cp /vagrant/scripts/sources.list /etc/apt/sources.list
  SHELL

  # controllers
  config.vm.define settings['controller']['hostname'] do |controller|
    controller.vm.hostname = settings['controller']['hostname']
    controller.vm.network "private_network", ip: settings['controller']['ip']

    controller.vm.provider "virtualbox" do |vb|
      vb.name = cluster_name + "_" + settings['controller']['hostname']
    end

    controller.vm.provision "base", type: "shell", path: "scripts/base.sh"
    controller.vm.provision "controller", type: "shell", path: "scripts/controller.sh"
  end

  # satellites
  settings['satellites']['nodes'].each do |sat|
    config.vm.define sat["hostname"] do |node|
      node.vm.hostname = sat['hostname']
      node.vm.network "private_network", ip: sat['ip']

      # disks
      sat['disks'].each do |disk|
        node.vm.disk :disk, name: disk['name'], size: disk['size']
      end

      node.vm.provider "virtualbox" do |vb|
        vb.name = cluster_name + "_" + sat['hostname']
      end

      node.vm.provision "base", type: "shell", path: "scripts/base.sh"
      node.vm.provision "satellite", type: "shell", env: {
        "CONTROLLERS" => settings['controller']['ip'],
      }, path: "scripts/satellite.sh"
    end
  end
end