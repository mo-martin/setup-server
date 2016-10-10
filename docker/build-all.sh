#!/bin/bash
eval "$(docker-machine env default)"

set +e
docker stop moses-app moses-api moses-db my-redis-db
docker rm moses-app moses-api moses-db my-redis-db

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

cp -r ~/sparta/multi-vagrant-project/app/ /tmp/node-app/app
cp -r ~/sparta/multi-vagrant-project/api/ /tmp/node-api/api
cp -r ~/sparta/sandbox/DevOpsDock/database/ /tmp/node-db/db
rm -rf /tmp/node-app/app/.git
rm -rf /tmp/node-app/app/.gitignore
rm -rf /tmp/node-api/api/.git
rm -rf /tmp/node-api/api/.gitignore

cp -r /tmp/node-app/app/ ./my-node-app/app
cp -r /tmp/node-api/api/ ./my-node-api/api
cp -r /tmp/node-db/db/ ./my-node-db/db

pushd my-nodejs
docker build --tag my-nodejs:latest .
popd
pushd my-node-app
docker build --tag my-node-app:latest .
popd
pushd my-node-api
docker build --tag my-node-api:latest .
popd
pushd my-node-db
docker build --tag my-node-db:latest .
popd
pushd my-redis
docker build --tag my-redis:latest .
popd

echo "Checking for the container my-redis"
set +e
docker ps -a |grep my-redis > /dev/null
FOUND_REDIS=$?
echo $FOUND_REDIS
set -e

if [[ "$FOUND_REDIS" == "0" ]]; then
  echo "Redis data store already exists"
else
  echo "Running the new container"
  docker create --name my-redis my-redis:latest
fi


echo "Running the rest"
docker run --name my-redis-db --volumes-from my-redis -d redis:latest
docker run --name moses-db -d my-node-db:latest
docker run --name moses-api --link moses-db:db -e DB_URL=mongodb://db/Poker -d my-node-api:latest
docker run --name moses-app -p 3000:3000 --link moses-api:api -e API_URL=http://api:3000 -d my-node-app:latest
docker ps -a
# docker run --name moses-db -p 27017:27017 -d my-node-db:latest
# docker run --name moses-api -p 3001:3000 -e DB_URL=mongodb://192.168.99.101/Poker -d my-node-api:latest
# docker run --name moses-app -p 3000:3000 -e API_URL=http://192.168.99.101:3001 -d my-node-app:latest
# docker ps -a
