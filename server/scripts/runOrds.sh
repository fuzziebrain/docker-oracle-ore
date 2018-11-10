#!/bin/bash

ORAENV_ASK=NO
ORACLE_SID=XE

. oraenv 

cd ${ORACLE_BASE}/product/ords

java -jar ords.war standalone