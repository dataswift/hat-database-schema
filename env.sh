#!/usr/bin/env bash

export DATABASE=${DATABASE:-"hat20"}
export DBUSER=${DBUSER:-$DATABASE}
export DBPASS=${DBPASS:-"pa55w0rd"}
export JDBCURL="jdbc:postgresql://localhost/$DATABASE"