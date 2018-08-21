#!/bin/bash

sqlplus -s $ORA_USER/$ORA_PASS<<EOF
set heading off
set feedback off
set serveroutput on
set pagesize 0
set tab off
@$1;
exit;
EOF

