#!/usr/bin/env bash

export DATABASE=${DATABASE:-"hat20"}
export DBUSER=${DBUSER:-$DATABASE}
export DBPASS=${DBPASS:-"pa55w0rd"}
export JDBCURL="jdbc:postgresql://localhost/$DATABASE"

export POSTGRES_DB=$DATABASE
export POSTGRES_USER=$DBUSER
export POSTGRES_PASSWORD=$DBPASS
export POSTGRES_HOST=localhost
export POSTGRES_PORT=5432