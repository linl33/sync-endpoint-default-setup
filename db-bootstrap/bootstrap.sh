#!/bin/sh -eu

set -o pipefail

echo "ODK Sync Database Bootstrap Script"

if [ ${DB_BOOTSTRAP} != true ]; then
    echo 'DB_BOOTSTRAP not set to true'
    echo 'Database bootstrap cancelled'
    exit 0
fi;

# sleep 5 seconds to wait for db service to be created
# TODO: test for it in a loop instead
sleep 5

STACK_NAME=$(docker ps -f "ID=${HOSTNAME}" --format '{{ .Names }}' | grep -oE '^[^_]*')
DB_VAR=$(docker service inspect -f "{{if eq \"${STACK_NAME}_db\" .Spec.Name}}{{.Spec.TaskTemplate.ContainerSpec.Image}}{{end}}" $(docker service ls -q) | grep -oE '^[^:]*')
DB_CONTAINER_ID=$(docker ps -f "volume=${STACK_NAME}_db-vol" --format '{{.ID}}')

# try to establish tcp connection with db, each connection timesout after 1 second 
WAIT_CMD="while ! nc -w 1 db \${DB_PORT} < /dev/null; do echo 'waiting'; sleep 1; done"

case ${DB_VAR} in
    postgres)
        echo "postgres db detected"
        DB_PORT=5432
        eval ${WAIT_CMD}
        docker exec ${DB_CONTAINER_ID} psql \
            -c 'CREATE USER odk WITH UNENCRYPTED PASSWORD '\''odk'\'';' \
            -c 'CREATE SCHEMA odk_sync AUTHORIZATION odk;' \
            -c 'GRANT ALL PRIVILEGES ON SCHEMA odk_sync TO odk;' \
            -U ${POSTGRES_USER} -d ${POSTGRES_DB}
        ;;
    mysql)
        echo "mysql db detected"
        DB_PORT=3306
        eval ${WAIT_CMD}
        docker exec ${DB_CONTAINER_ID} mysql \
            -e 'CREATE DATABASE odk_sync;' \
            -e 'GRANT USAGE ON *.* TO odk@% IDENTIFIED BY '\''odk'\'';' \
            -e 'GRANT ALL PRIVILEGES ON odk_sync.* TO odk@%;' \
            -p"${MYSQL_ROOT_PASSWORD}"
        ;;
    sqlserver)
        echo "sqlserver db detected"
        ;;
    *)
        echo "Error"
        echo "${DB_VAR} not supported"
        ;;
esac

echo "Done"

# TODO ping Sync after db bootstrap done

exit 0