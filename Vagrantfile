# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|
  config.vm.define "app" do |app|
    app.vm.box = "bento/ubuntu-16.04"
    app.vm.hostname = 'app'
    app.vm.network :private_network, ip: "192.10.10.100"
    app.vm.network :forwarded_port, guest: 80 , host: 3000
    app.vm.synced_folder "webservers/", "/root/server-setup/webservers"
    app.vm.synced_folder "../app", "/var/www/html"
    app.vm.provision "shell", path: "webservers/setup.sh"
    app.vm.provision "shell", inline: "sudo usermod -a -G www-data vagrant"
  end

  config.vm.define "api" do |api|
    api.vm.box = "bento/ubuntu-16.04"
    api.vm.hostname = 'api'
    api.vm.network :private_network, ip: "192.10.10.150"
    api.vm.network :forwarded_port, guest: 80 , host: 3001
    api.vm.synced_folder "webservers/", "/root/server-setup/webservers"
    api.vm.synced_folder "../app", "/var/www/html"
    api.vm.provision "shell", path: "webservers/setup.sh"
    api.vm.provision "shell", inline: "sudo usermod -a -G www-data vagrant"
  end

  config.vm.define "db" do |db|
    db.vm.box = "bento/ubuntu-16.04"
    db.vm.hostname = 'db'
    db.vm.network :private_network, ip: "192.10.10.200"
    db.vm.synced_folder "database/", "/root/server-setup/database"
    db.vm.provision "shell", path: "database/setup.sh"
  end
end
