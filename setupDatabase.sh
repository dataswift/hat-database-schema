#!/usr/bin/env bash

#export PGUSER=postgres #force the user to be postgres, to ensure permissions in following commands

# Create the DB
# NOSUPERUSER NOCREATEDB NOCREATEROLE
echo "Setting up database user and database"
echo "dbuser: $DBUSER, database: $DATABASE"
createuser -S -D -R -e $DBUSER
createdb $DATABASE -O $DBUSER
psql $DATABASE -c "ALTER USER $DBUSER WITH PASSWORD '$DBPASS';"

#DBUSER wouldnt have required permissions to drop/create public schema otherwise
echo "Handling schemas"
psql $DATABASE -c 'DROP SCHEMA public CASCADE;'
psql $DATABASE -c 'CREATE SCHEMA public;'
psql $DATABASE -c "ALTER SCHEMA public OWNER TO $DBUSER;"

echo "Setting up database"
psql $DATABASE -c 'CREATE EXTENSION "uuid-ossp";'
psql $DATABASE -c 'CREATE EXTENSION "pgcrypto";'

export PGPASSWORD="$DBPASS" #use the given password for the next psql commands with user DBUSER