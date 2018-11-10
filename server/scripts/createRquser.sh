#!/bin/bash

ORAENV_ASK=NO
ORACLE_SID=XE

. oraenv

cd $ORACLE_HOME/R/server

sqlplus -s / as sysdba << EOF
  alter session set container = XEPDB1;
  create user $1 identified by "$2"
  default tablespace users
  temporary tablespace temp
  quota unlimited on users;
  @rqgrant $1
EOF