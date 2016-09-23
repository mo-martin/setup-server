#!/bin/bash
sudo apt-get update -y
# git
sudo apt-get install git -y
# nginx
sudo apt-get install nginx -y
sudo cp ~/servers/webservers/default /etc/nginx/sites-enabled/default -f
sudo service nginx restart
# npm and nodejs
sudo apt-get install npm -y
sudo apt-get install nodejs -y
sudo ln -s /usr/bin/nodejs /usr/bin/node
# mongodb
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
sudo apt-get update -y
sudo apt-get install -y mongodb-org
sudo cp ~/servers/webservers/mongodb.service /etc/systemd/system/mongodb.service -f
sudo systemctl start mongodb
# pm2
sudo npm install pm2 -g
# Adding users and permissions
sudo chown www-data:www-data /var/www -R
sudo adduser --disabled-password --gecos "" production-user
sudo adduser production-user www-data
sudo chmod -R 775 /var/www
sudo rm /var/www/html/index*
