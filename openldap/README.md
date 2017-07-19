## Run 

1. Follow instructions on [sync-endpoint-containers](https://github.com/jbeorse/sync-endpoint-containers) to create the Docker Secrets/Configs
2. Create a Docker Overlay network for LDAP communication with the following command 
`docker network create --opt encrypted --driver overlay ldap-network`
3. To run OpenLDAP + phpLDAPadmin, use `docker stack deploy -d docker-compose.yml openldap`  
To run OpenLDAP + phpLDAPadmin + Sync, use `docker stack deploy -d docker-compose-with-sync.yml syncldap`
4. Tweak parameters in `ldap.env`, `sync.env`, `docker-compose.yml` and `docker-compose-with-sync.yml` if needed

## Notes 

The OpenLDAP container is from [osixia/openldap](https://github.com/osixia/docker-openldap)

The phpLDAPadmin container is from [osixia/phpldapadmin](https://github.com/osixia/docker-phpLDAPadmin)

Refer to their respecitve documentations for usage information. 
