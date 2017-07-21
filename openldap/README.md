## Run 

1. Follow instructions on [sync-endpoint-containers](https://github.com/jbeorse/sync-endpoint-containers) to create the Docker Secrets/Configs
2. Create a Docker Overlay network for LDAP communication with the following command  
   `docker network create --opt encrypted --driver overlay ldap-network`
3. Tweak parameters in `ldap.env`, `sync.env`, `docker-compose.yml` and `docker-compose-with-sync.yml` if needed
4. To run OpenLDAP + phpLDAPadmin, use  
   `docker stack deploy -c docker-compose.yml openldap`  
   To run OpenLDAP + phpLDAPadmin + Sync, use  
   `docker stack deploy -c docker-compose-with-sync.yml syncldap`

Populate the LDAP directory with preset groups, use the following command, 

`GROUP_PREFIX=group_prefix envsubst < bootstrap.ldif | docker exec -i $(docker ps --format '{{ .Names }} {{.ID }}' | grep ldap_ldap-service | grep -oE "[^ ]+$") ldapadd -x -D 'cn=admin,dc=example,dc=org' -w admin`

## Notes 

The OpenLDAP container is from [osixia/openldap](https://github.com/osixia/docker-openldap)

The phpLDAPadmin container is from [osixia/phpldapadmin](https://github.com/osixia/docker-phpLDAPadmin)

Refer to their respecitve documentations for usage information. 
