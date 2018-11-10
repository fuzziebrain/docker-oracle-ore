#!/bin/bash

ORAENV_ASK=NO
ORACLE_SID=XE

. oraenv 

ORDS_HOME=${ORACLE_BASE}/product/ords
APEX_IMAGE_PATH=${ORACLE_BASE}/product/apex/images
ORDS_CONFIG_DIR=${ORDS_HOME}/conf

cd ${ORDS_HOME}

cat << EOF > ${ORDS_HOME}/params/custom_params.properties
db.hostname=localhost
db.password=${ORACLE_PASSWORD}
db.port=1521
db.servicename=XEPDB1
db.username=APEX_PUBLIC_USER
plsql.gateway.add=true
rest.services.apex.add=true
rest.services.ords.add=true
schema.tablespace.default=SYSAUX
schema.tablespace.temp=TEMP
standalone.http.port=8080
standalone.mode=true
standalone.static.images=${APEX_IMAGE_PATH}
standalone.use.https=false
user.apex.listener.password=${ORACLE_PASSWORD}
user.apex.restpublic.password=${ORACLE_PASSWORD}
user.public.password=${ORACLE_PASSWORD}
user.tablespace.default=SYSAUX
user.tablespace.temp=TEMP
sys.user=sys
sys.password=${ORACLE_PASSWORD}
EOF

java -jar ords.war configdir ${ORDS_CONFIG_DIR}

java -jar ords.war install simple --parameterFile ${ORDS_HOME}/params/custom_params.properties