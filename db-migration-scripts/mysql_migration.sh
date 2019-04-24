#!/bin/bash

SOURCE_DB_HOST=$1
SOURCE_DB_USERNAME=$2
SOURCE_DB_PWD=$3
SOURCE_DB_NAME=$4

DEST_DB_HOST=$5
DEST_DB_USERNAME=$6
DEST_DB_PWD=$7


echo "Inputs parsed going to create mysqldump"

rm -f all_databases.sql

mysqldump --routines -h ${SOURCE_DB_HOST} -u ${SOURCE_DB_USERNAME} -p${SOURCE_DB_PWD} --databases ${SOURCE_DB_NAME} > all_databases.sql
sed -i 's/DEFINER=`${SOURCE_DB_USERNAME}`\@`\%`//g' all_databases.sql
echo "SqlDump file generated from source DB. Going run it in destination DB"

mysql -h ${DEST_DB_HOST} -u ${DEST_DB_USERNAME} -p${DEST_DB_PWD} < all_databases.sql

echo "Destination DB refreshed from source DB"
