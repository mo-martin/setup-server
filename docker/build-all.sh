#!/bin/bash
# eval "$(docker-machine env default)"

set +e
docker stop moses-app
docker rm moses-app
docker stop moses-api
docker rm moses-api
docker stop moses-db
docker rm moses-db
find my-node-api/api/* -type d -not -name '.gitignore' -print0 | xargs -0 rm -rf --
find my-node-app/app/* -type d -not -name '.gitignore' -print0 | xargs -0 rm -rf --
find my-node-db/db/* -type d -not -name '.gitignore' -print0 | xargs -0 rm -rf --
set -e

rm -rf /tmp/node-api/api
rm -rf /tmp/node-app/app
rm -rf /tmp/node-db/db
mkdir -p /tmp/node-app/app
mkdir -p /tmp/node-api/api
mkdir -p /tmp/node-db/db

cp -r ~/project/app/. /tmp/node-app/app/
cp -r ~/project/api/. /tmp/node-api/api/
cp -r ~/project/servers/database/. /tmp/node-db/db/
rm -rf /tmp/node-app/app/.git
rm -rf /tmp/node-app/app/.gitignore
rm -rf /tmp/node-api/api/.git
rm -rf /tmp/node-api/api/.gitignore

cp -r /tmp/node-app/app/. ./my-node-app/app/
cp -r /tmp/node-api/api/. ./my-node-api/api/
cp -r /tmp/node-db/db/. ./my-node-db/db/

pushd my-nodejs
docker build --tag my-nodejs:latest .
popd
# pushd my-node-app
# docker build --tag my-node-app:latest .
# popd
# pushd my-node-api
# docker build --tag my-node-api:latest .
# popd
# pushd my-node-db
# docker build --tag my-node-db:latest .
# popd
# pushd my-mongodb-data
# docker build --tag my-mongodb-data:latest .
# popd

# echo -e "\033[0;31mChecking for my-mongodb-data \033[0m"
# set +e
# docker ps -a | grep my-mongodb-data > /dev/null
# FOUND_MONGO=$?
# set -e
#
# echo $FOUND_MONGO
# if [[ "$FOUND_MONGO" == "0" ]]; then
#   echo "Mongodb data store already exists"
# else
#   echo "creating mongo data container"
#   docker create --name my-mongodb-data my-mongodb-data:latest
# fi
#
# echo "running everything else"
# docker run --name moses-db -p 27017:27017 --volumes-from my-mongodb-data -d my-node-db:latest
# docker run --name moses-api -p 3001:3000 -e DB_URL=mongodb://192.168.99.100/Poker -d my-node-api:latest
# docker run --name moses-app -p 3000:3000 -e API_URL=http://192.168.99.100:3001 -d my-node-app:latest
# docker ps -a
