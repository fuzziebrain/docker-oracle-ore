# Up and Running with Oracle R Enterprise in 18c XE

## Project Scope

The code and documentation in this repository are solely for the purpose of demonstrate the usage of [Oracle R Enterprise](https://www.oracle.com/technetwork/database/database-technologies/r/r-enterprise/overview/index.html) (ORE) with [Oracle Database 18c Express Edition](https://oracle.com/xe) (XE), and not intended to be used in development or production. It is provided as-is. Maintenance and support is not guaranteed. 

The code was developed and known to execute successfully given the following software versions and environment.

| Software | Version |
|-|-|
| Ubuntu | Ubuntu 18.04.1 LTS |
| Docker | 18.06.1-ce (minimum 17.12.0+) |
| Oracle Database | 18c XE |
| Oracle R Enterprise | 1.5.1 |
| R | 3.3.0 |
| APEX | 18.2 |
| ORDS | 18.3 |

## Required Downloads from Oracle

Download the following files and place them in the directory: `./client/files`:

* [Oracle R Enterprise](https://www.oracle.com/technetwork/database/database-technologies/r/r-enterprise/downloads/index.html) Client - `ore-server-linux-x86-64-1.5.1.zip`

Download the following files and place them in the directory: `./server/files`:

* [Oracle 18c XE](https://www.oracle.com/technetwork/database/database-technologies/express-edition/downloads/index.html) - `oracle-database-xe-18c-1.0-1.x86_64.rpm`
* [Oracle R Enterprise](https://www.oracle.com/technetwork/database/database-technologies/r/r-enterprise/downloads/index.html) Server - `ore-server-linux-x86-64-1.5.1.zip`

## Running the Services

### 1. Oracle Database XE with ORE Configured

```bash
$ docker-compose up -d && docker logs -f ore-server
```

### 2. Create a User for ORE

> IMPORTANT Wait till the Oracle Database has started successfully before proceeding to the next step.

```bash
$ ./bin/createUser.sh <USERNAME> <PASSWORD>
```

Note that the user will require additional privileges, e.g. for use with APEX:

```sql
grant create cluster to demo;
grant create dimension to demo;
grant create indextype to demo;
grant create job to demo;
grant create materialized view to demo;
grant create operator to demo;
grant create sequence to demo;
grant create synonym to demo;
grant create trigger to demo;
grant create type to demo;
```

Grant RQADMIN for elevated privileges to create scripts.

```sql
grant rqadmin to demo;
```

### 3. Accessing the Database

Connect to the database as the user created in the earlier step. Create a simple table.

```bash
$ ./bin/dbclient.sh 
The Oracle base remains unchanged with value /opt/oracle

SQL*Plus: Release 18.0.0.0.0 - Production on Fri Nov 9 03:15:52 2018
Version 18.4.0.0.0

Copyright (c) 1982, 2018, Oracle.  All rights reserved.

SQL> connect <USERNAME>/<PASSWORD>@//ore-server:1521/XEPDB1
Connected.
SQL> create table sample(x number, y number);

Table created.
```

### 4. ORE Client

> NOTE The script will build the image if necessary.

```bash
$ ./bin/rclient.sh
```

### 5. Connecting to the Database using ORE Client

Connect to the database, synchronize the schema and then list the objects. The table created earlier should be listed.

```R
> library(ORE)
> ore.connect(
+   user='<USERNAME>'
+   , password='<PASSWORD>'
+   , conn_string='//ore-server:1521/XEPDB1'
+ )
>
> ore.ls()
> ore.ls()
character(0)
> ore.sync('RUSER')
> ore.ls()
[1] "SAMPLE"
> ore.disconnect()
```

## TODO

* Update Docker image to allow persistence of APEX/ORDS configuration and resources.


## Credits

Dockerfile and scripts are based on previous works:

* https://github.com/oracle/docker-images
* https://github.com/fuzziebrain/docker-oracle-xe