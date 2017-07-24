## Prerequisites

Same as [sync-endpoint-containers](https://github.com/jbeorse/sync-endpoint-containers)

## Build 

1. Follow instructions on [sync-endpoint-containers](https://github.com/jbeorse/sync-endpoint-containers) to build `odk/sync_endpoint`
2. Build `db-bootstrap` with `docker build -t odk/db-bootstrap db-bootstrap`
3. Build `openldap` with `docker build -t odk/openldap openldap`
4. Build `phpldapadmin` with `docker build -t odk/phpldapadmin phpldapadmin`

## Run 

1. Tweak parameters in `ldap.env`, `sync.env`, `db.env`, `jdbc.properties`, `security.properties`, `docker-compose.yml` if needed  
   Note: `jdbc.properties` and `docker-compose.yml` have been configured to use PostgreSQL but MySQL is also supported. 
2. `docker stack deploy -c docker-compose.yml syncldap` to deploy all services
3. Navigate to `https://127.0.0.1:40000` and create a user, see the [LDAP](#ldap) section below for detail
4. Sync endpoint is now running at `http://127.0.0.1`

## Clean up

1. Remove the stack with, `docker stack rm syncldap`
2. Remove volumes with, `docker volume rm $(docker volume ls -f "label=com.docker.stack.namespace=syncldap" -q)`

## LDAP

TODO

## Notes 

The OpenLDAP container is from [osixia/openldap](https://github.com/osixia/docker-openldap)

The phpLDAPadmin container is from [osixia/phpldapadmin](https://github.com/osixia/docker-phpLDAPadmin)

Refer to their respecitve documentations for usage information. 
