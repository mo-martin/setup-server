# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "test" do |test|
    test.vm.box = "bento/ubuntu-16.04"
    test.vm.hostname = "test"
    test.vm.synced_folder "cookbooks/", "/home/vagrant/cookbooks"
  end


  config.vm.define "app" do |app|
    app.vm.box = "bento/ubuntu-16.04"
    app.vm.hostname = "app"
    app.vm.synced_folder "webserver/", "/root/servers/webserver"
    app.vm.synced_folder "../app", "/var/www/html"
    app.vm.provision "shell", inline: "sudo usermod -a -G www-data vagrant"
    app.vm.provision "shell", inline: "sudo apt-get install curl"
    app.vm.provision "shell", inline: "curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 0.16.28"
    app.vm.provision "shell", inline: "sudo chef-client --local-mode --runlist 'recipe[webserver]'"
    app.vm.network :private_network, ip: "192.10.10.100"
    app.vm.synced_folder "cookbooks/", "/home/vagrant/cookbooks"
  end

  config.vm.define "api" do |api|
    api.vm.box = "bento/ubuntu-16.04"
    api.vm.hostname = "api"
    api.vm.synced_folder "webserver/", "/root/servers/webserver"
    api.vm.synced_folder "../api", "/var/www/html"
    api.vm.provision "shell", inline: "sudo usermod -a -G www-data vagrant"
    api.vm.provision "shell", inline: "sudo apt-get install curl"
    api.vm.provision "shell", inline: "curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 0.16.28"
    api.vm.provision "shell", inline: "sudo chef-client --local-mode --runlist 'recipe[webserver]'"
    api.vm.network :private_network, ip: "192.10.10.150"
    api.vm.synced_folder "cookbooks/", "/home/vagrant/cookbooks"
  end

  config.vm.define "db" do |db|
    db.vm.box = "bento/ubuntu-16.04"
    db.vm.hostname = "db"
    db.vm.synced_folder "database/", "/root/servers/database"
    db.vm.provision "shell", inline: "sudo apt-get install curl"
    db.vm.provision "shell", inline: "curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 0.16.28"
    db.vm.provision "shell", inline: "sudo chef-client --local-mode --runlist 'recipe[database]'"
    db.vm.network :private_network, ip: "192.10.10.200"
    db.vm.synced_folder "cookbooks/", "/home/vagrant/cookbooks"
  end
end
