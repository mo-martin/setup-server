#
# Cookbook Name:: webserver
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

apt_update 'Update the cache daily' do
  frequency 86_400
  action :periodic
end

package 'git'
package 'nginx'
package 'npm'
package 'nodejs'


service 'nginx' do
  supports "status" => true
  action [:enable, :start]
end

template '/etc/nginx/sites-enabled/default' do
  source 'default.nginx.erb'
end

link '/usr/bin/nodejs' do
  to '/usr/bin/node'
end

directory '/var/www' do
  owner 'www-data'
  group 'www-data'
  mode '0775'
  action :create
end

execute "sudo npm install pm2 -g" do
  command "sudo npm install pm2 -g"
end
