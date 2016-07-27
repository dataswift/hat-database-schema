#!/usr/bin/env bash

export DATABASE=${DATABASE_NAME:-"hat211"}
export DBUSER=${DATABASE_USER:-$DATABASE}
export DBPASS=${DATABASE_PASSWORD:-"pa55w0rd"}
export JDBCURL="jdbc:postgresql://localhost/$DATABASE"

export POSTGRES_DB=$DATABASE
export POSTGRES_USER=$DBUSER
export POSTGRES_PASSWORD=$DBPASS
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432