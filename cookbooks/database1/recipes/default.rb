#
# Cookbook Name:: database
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'mongodb'

execute "Generate keyserver" do
  command "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927"
end

execute "Download mongodb" do
  command "echo \"deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse\" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
  sudo apt-get update"
end

apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end

template '/etc/systemd/system/mongodb.service' do
  source 'mongodb.service.erb'
end

service 'mongodb' do
  supports "status" => true
  action [:enable, :start]
end
execute "Iptables exceptions" do
  command "sudo iptables -A INPUT -s 192.10.10.100,192.10.10.150 -p tcp --destination-port 27017 -m state --state NEW,ESTABLISHED -j ACCEPT"
end
