#
# Cookbook Name:: db
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
execute "add key" do
  command "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927"
end
execute "add mongo to list" do
  command 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
  sudo apt-get update'
end
apt_update 'Update the apt cache daily' do
  frequency 86_400
  action :periodic
end
package 'mongodb-org'
template '/etc/systemd/system/mongodb.service' do
 source 'mongodb.service.erb'
end
template '/etc/mongod.conf' do
 source 'mongod.conf'
end
service 'mongod' do
  action [ :start ]
end
