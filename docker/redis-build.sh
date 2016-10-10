#!/bin/bash
eval "$(docker-machine env default)"

set +e
docker stop my-redis-db
docker rm my-redis-db
set -e

pushd my-redis-data
docker build --tag my-redis-data:latest .
popd

echo "Checking for my-redis-data"
set +e
docker ps -a | grep my-redis-data > /dev/null
FOUND_REDIS=$?
set -e

if [[ "$FOUND_REDIS" == "0" ]]; then
 echo "Redis data store already exists"
else
 echo "Running data container"
 docker run --name my-redis-data -d my-redis-data:latest
fi

docker run --name my-redis-db --volumes-from my-redis-data -d redis:latest
docker ps -a
