FROM oraclelinux:7 as base
LABEL MAINTAINER "Adrian Png< adrian.png@fuzziebrain.com>"

ENV \
  CRAN_MIRROR_URL=https://cran.r-project.org \
  # DO NOT CHANGE #
  ORE_CLIENT_FILE=ore-client-linux-x86-64-1.5.1.zip \
  ORE_SUPPORTING_FILE=ore-supporting-linux-x86-64-1.5.1.zip \
  PATH=$PATH:/usr/lib/oracle/18.3/client64/bin \
  OCI_LIB=/usr/lib/oracle/18.3/client64/lib \
  OCI_INC=/usr/include/oracle/18.3/client64

COPY Rprofile.site /tmp

RUN \
  curl -o /etc/yum.repos.d/public-yum-ol7.repo https://yum.oracle.com/public-yum-ol7.repo && \
  yum-config-manager --enable ol7_addons ol7_optional_latest ol7_oracle_instantclient && \
  yum install -y \
    oracle-instantclient18.3-basic \
    oracle-instantclient18.3-devel \
    oracle-instantclient18.3-sqlplus \
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
  sed -i s^CRAN_MIRROR_URL^${CRAN_MIRROR_URL}^ /usr/lib64/R/etc/Rprofile.site && \
  echo /usr/lib/oracle/18.3/client64/lib > /etc/ld.so.conf.d/oracle-instantclient18.3.conf && \
  ldconfig

FROM base

COPY files/${ORE_CLIENT_FILE} /tmp
COPY files/${ORE_SUPPORTING_FILE} /tmp

RUN \
  unzip /tmp/${ORE_CLIENT_FILE} -d /ore && \
  unzip /tmp/${ORE_SUPPORTING_FILE} -d /ore && \
  R -e "install.packages(c('png','DBI','ROracle','randomForest','statmod','Cairo'), repos='${CRAN_MIRROR_URL}')" && \
  R CMD INSTALL /ore/supporting/arules_1.5-0_R_x86_64-unknown-linux-gnu.tar.gz && \
  for f in `ls /ore/client/*.tar.gz`; do R CMD INSTALL $f; done;
