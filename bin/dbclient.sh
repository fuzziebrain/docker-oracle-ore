#!/bin/bash

docker exec -u oracle -it \
  -e ORAENV_ASK=NO \
  -e ORACLE_SID=XE \
  ore-server bash \
  -c ". oraenv && sqlplus /nolog"
