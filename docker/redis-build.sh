#!/bin/bash
eval "$(docker-machine env default)"

set +e
docker stop my-redis-db
docker rm my-redis-db
set -e

pushd my-redis-data
docker build --tag my-redis-data:latest .
popd

echo -e "\033[0;31mChecking for my-redis-data \033[0m"
set +e
docker ps -a | grep my-redis-data > /dev/null
FOUND_REDIS=$?
set -e

if [[ "$FOUND_REDIS" == "0" ]]; then
 echo -e "\033[0;32mRedis data store already exists\033[0m"
else
 echo -e "\033[1;33mRunning data container\033[0m"
 docker create --name my-redis-data my-redis-data:latest
fi

docker run --name my-redis-db --volumes-from my-redis-data -d redis:latest
docker ps -a
