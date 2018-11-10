#!/bin/bash

ORE_CLIENT_IMAGE=ore-client
ORE_NETWORK_NAME=ore_network

if [[ "$(docker images -q ${ORE_CLIENT_IMAGE} 2> /dev/null)" == "" ]]; then
  docker build -t ${ORE_CLIENT_IMAGE} client
fi

docker run -it --rm \
  --network ${ORE_NETWORK_NAME} \
  -e CRAN_MIRROR_URL=https://cran.r-project.org \
  ${ORE_CLIENT_IMAGE} \
  R