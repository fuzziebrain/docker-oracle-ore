#!/bin/bash

docker exec -u oracle ore-server \
  /opt/oracle/scripts/createRquser.sh $1 $2