#!/bin/bash

MIGRATION_HOST=$1
MIGRATION_HOST_USERNAME=$2
MIGRATION_HOST_KEY=$3

SOURCE_DB_HOST=$4
SOURCE_DB_USERNAME=$5
SOURCE_DB_PWD=$6
SOURCE_DB_NAME=$7

DEST_DB_HOST=$8
DEST_DB_USERNAME=$9
DEST_DB_PWD=${10}


echo "Inputs parsed going to create mysqldump"

rm -f all_databases.sql

ssh -i ${MIGRATION_HOST_KEY} ${MIGRATION_HOST_USERNAME}@${MIGRATION_HOST} "mysqldump --routines -h ${SOURCE_DB_HOST} -u ${SOURCE_DB_USERNAME} -p${SOURCE_DB_PWD} --databases ${SOURCE_DB_NAME}" > all_databases.sql
sed -i 's/DEFINER=`${SOURCE_DB_USERNAME}`\@`\%`//g' all_databases.sql
echo "SqlDump file generated from source DB. Going run it in destination DB"

mysql -h ${DEST_DB_HOST} -u ${DEST_DB_USERNAME} -p${DEST_DB_PWD} < all_databases.sql

echo "Destination DB refreshed"
