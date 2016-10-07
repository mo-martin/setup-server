#!/bin/bash
sudo apt-get update -y
# git
sudo apt-get install git nginx nodejs npm build-essential nodejs-legacy node-daemon -y
sudo cp ~/server-setup/webservers/default /etc/nginx/sites-enabled/default -f
sudo service nginx restart
# npm and nodejs
sudo ln -s /usr/bin/nodejs /usr/bin/node
# Adding users and permissions
sudo chown www-data:www-data /var/www -R
sudo adduser --disabled-password --gecos "" production-user
sudo adduser production-user www-data
sudo chmod -R 775 /var/www
# pm2
sudo npm install pm2 -g


file="/var/www/html/*"
if [ -f "$file" ]
then
	sudo rm /var/www/html/index*
fi
