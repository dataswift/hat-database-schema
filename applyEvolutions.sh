#!/usr/bin/env bash

## declare an array of evolutions
declare -a evolutions=(
    "11_hat" "12_hatEvolutions" "31_properties" "32_relationships"
    "33_staticData" "35_sampleCollections" "41_authentication")

jdbcurl=$JDBCURL
dbuser=$DBUSER
dbpass=$DBPASS

# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# > 1 ]]
do
key="$1"

case $key in
    -c|--contexts)
    CONTEXTS="$2"
    shift # past argument
    ;;
    -t|--task)
    TASK="$2"
    shift # past argument
    ;;
    *)
            # unknown option
    ;;
esac
shift # past argument or value
done
echo "Running Evolutions on $CONTEXTS contexts"

CLASSPATH=postgresql-9.4.1208.jre6.jar

if [[ $TASK == 'dropAll' ]]; then
   echo "Drop All"
       ./liquibase --changeLogFile=01_init.sql \
          --username=$dbuser \
          --password=$dbpass \
          --url=$jdbcurl \
          --classpath=$CLASSPATH \
          --liquibaseSchemaName=public \
          --defaultSchemaName=hat \
          dropAll
else
  if [[ $CONTEXTS == '' ]]; then
    echo "Must specify evolution contexts via -c or --contexts: 'structuresonly', 'data', 'testdata' or a combination of those"
  else
    ## now loop through the above array
    for i in "${evolutions[@]}"
    do
       echo "Evolution $i.sql"
       ./liquibase --changeLogFile=$i.sql \
          --contexts=$CONTEXTS \
          --username=$dbuser \
          --password=$dbpass \
          --url=$jdbcurl \
          --classpath=$CLASSPATH \
          --liquibaseSchemaName=public \
          --defaultSchemaName=hat \
          update
    done
  fi
fi
