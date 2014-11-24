#!/bin/bash

NI_DIR="/nidata"

cat /nidata/psql.txt | sudo -u postgres psql

cat /nidata/newint2.sql | sudo -u newint2 psql newint2

cat /nidata/join_views.sql | sudo -u newint2 psql newint2
