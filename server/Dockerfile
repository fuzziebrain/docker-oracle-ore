FROM oraclelinux:7-slim as database
LABEL MAINTAINER "Adrian Png <adrian.png@fuzziebrain.com>"

ENV \
  # The only environment variable that should be changed!
  ORACLE_PASSWORD=Oracle18 \
  CRAN_MIRROR_URL=https://cran.r-project.org \
  APEX_ADMIN_EMAIL=changeme@domain.network \
  APEX_ADMIN_PASSWORD=ApexIs#1 \
  # DO NOT CHANGE 
  ORACLE_DOCKER_INSTALL=true \
  ORACLE_SID=XE \
  ORACLE_BASE=/opt/oracle \
  ORACLE_HOME=/opt/oracle/product/18c/dbhomeXE \
  ORAENV_ASK=NO \
  RUN_FILE=runOracle.sh \
  SHUTDOWN_FILE=shutdownDb.sh \
  EM_REMOTE_ACCESS=enableEmRemoteAccess.sh \
  EM_RESTORE=reconfigureEm.sh \
  ORE_SETUP=enableORE.sh \
  APEX_INSTALL=installApex.sh \
  ORDS_INSTALL=installOrds.sh \
  ORDS_RUN=runOrds.sh \
  ORACLE_XE_RPM=oracle-database-xe-18c-1.0-1.x86_64.rpm \
  ORE_SERVER_FILE=ore-server-linux-x86-64-1.5.1.zip \
  ORE_SUPPORTING_FILE=ore-supporting-linux-x86-64-1.5.1.zip \
  APEX_FILE=apex_18.2.zip \
  ORDS_FILE=ords-18.3.0.270.1456.zip \
  CHECK_DB_FILE=checkDBStatus.sh
    
COPY ./files/${ORACLE_XE_RPM} /tmp/
COPY ./files/${APEX_FILE} /tmp/
COPY ./files/${ORDS_FILE} /tmp/

RUN \
  yum install -y \
    oracle-database-preinstall-18c \
    java-1.8.0-openjdk \
    && \
  yum install -y /tmp/${ORACLE_XE_RPM} && \
  rm -rf /tmp/${ORACLE_XE_RPM} && \
  unzip /tmp/${APEX_FILE} -d ${ORACLE_BASE}/product/ && \
  unzip /tmp/${ORDS_FILE} -d ${ORACLE_BASE}/product/ords && \
  chown -R oracle:oinstall ${ORACLE_BASE}/product/

COPY ./scripts/*.sh ${ORACLE_BASE}/scripts/

RUN chmod a+x ${ORACLE_BASE}/scripts/*.sh 


FROM database as rbase

COPY Rprofile.site /tmp

RUN \
  yum-config-manager --enable ol7_addons ol7_optional_latest && \
  yum install -y \
    make \
    automake \
    gcc \
    gcc-c++ \
    pango-devel \
    libpng12 \
    unzip \
    R.x86_64 \
    && \
  rm -rf /var/cache/yum && \
  mkdir /usr/share/doc/R-$(rpm -q R.x86_64 --queryformat '%{VERSION}')/html && \
  mv /tmp/Rprofile.site /usr/lib64/R/etc && \
  sed -i s^CRAN_MIRROR_URL^${CRAN_MIRROR_URL}^ /usr/lib64/R/etc/Rprofile.site

# FROM rbase as rserver

# RUN \
#   R -e "install.packages(c('png', 'Cairo', 'ROracle'), repos='${CRAN_MIRROR_URL}')" 

# COPY files/${ORE_SERVER_FILE} /tmp

# RUN \
#   unzip /tmp/${ORE_SERVER_FILE} -d /ore && \
#   chown -R oracle:oinstall /ore

# 1521: Oracle listener
# 5500: Oracle Enterprise Manager (EM) Express listener.
EXPOSE 1521 5500 8080

VOLUME [ "${ORACLE_BASE}/oradata" ]

HEALTHCHECK --interval=1m --start-period=2m --retries=8 \
  CMD "$ORACLE_BASE/scripts/$CHECK_DB_FILE"

CMD exec ${ORACLE_BASE}/scripts/${RUN_FILE}