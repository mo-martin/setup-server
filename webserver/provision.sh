#!/bin/bash
cd ~
sudo apt-get update
sudo apt-get install git nginx nodejs npm build-essential nodejs-legacy -y

# sudo ln -s /usr/bin/nodejs /usr/bin/node

#Add a user and group
#adduser --disabled-password --gecos "" greg
#addgroup greg
#adduser greg greg
#sudo chown -R greg:greg /var/www/html
#usermod -g greg www-data

#sudo rm -rf /var/www/html
#mkdir /var/www/html


sudo tee -a /etc/nginx/sites-available/default <<EOF
server {
   listen 80;
   server_name localhost:3000;
   location / {
       proxy_pass http://localhost:8085;
       proxy_http_version 1.1;
       proxy_set_header Upgrade $http_upgrade;
       proxy_set_header Connection 'upgrade';
       proxy_set_header Host $host;
       proxy_cache_bypass $http_upgrade;
   }
}
EOF

sudo cp ~/servers/webserver/default /etc/nginx/sites-available/default -f
sudo chown -R www-data:www-data /var/www
sudo chmod -R 775 /var/www
sudo service nginx restart

#Run the app in the background of the code
#npm install
sudo npm install pm2 -g
pm2 kill
#pm2 start app.js
