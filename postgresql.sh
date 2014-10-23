#!/bin/bash

NI_DIR="/nidata"

sudo locale-gen en_US.UTF-8

sudo update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 LC_MONETARY=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8 LC_PAPER=en_US.UTF-8 LC_NAME=en_US.UTF-8 LC_ADDRESS=en_US.UTF-8 LC_TELEPHONE=en_US.UTF-8 LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=en_US.UTF-8 LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8 LC_NUMERIC=en_US.UTF-8 LC_TIME=en_US.UTF-8 LC_COLLATE=en_US.UTF-8 LC_MONETARY=en_US.UTF-8 LC_MESSAGES=en_US.UTF-8 LC_PAPER=en_US.UTF-8 LC_NAME=en_US.UTF-8 LC_ADDRESS=en_US.UTF-8 LC_TELEPHONE=en_US.UTF-8 LC_MEASUREMENT=en_US.UTF-8 LC_IDENTIFICATION=en_US.UTF-8 LC_ALL=en_US.UTF-8

sudo apt-get install postgresql-9.1 -y

sudo -u postgres pg_dumpall > /tmp/postgres.sql

sudo pg_dropcluster --stop 9.1 main

sudo pg_createcluster --locale en_US.UTF-8 --start 9.1 main

sudo -u postgres psql -f /tmp/postgres.sql

cat /nidata/psql.txt | sudo -u postgres psql

cat /nidata/newint2.sql | sudo -u newint2 psql newint2

cat /nidata/join_views.sql | sudo -u newint2 psql newint2
