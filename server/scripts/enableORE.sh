#!/bin/bash

ORAENV_ASK=NO
ORACLE_SID=XE
R_HOME=/usr/lib64/R

. oraenv

sh ${ORACLE_HOME}/bin/ORE -e "install.packages(c('png','DBI','ROracle','randomForest','statmod','Cairo'))" 

cd $ORACLE_HOME/R/server

sqlplus -s / as sysdba << EOF
  alter session set container = XEPDB1;
  @rqcfg SYSAUX TEMP $ORACLE_HOME $R_HOME
EOF