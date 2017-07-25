## Prerequisites

Same as [sync-endpoint-containers](https://github.com/jbeorse/sync-endpoint-containers)

## Build

1. Follow instructions on [sync-endpoint-containers](https://github.com/jbeorse/sync-endpoint-containers) to build `odk/sync_endpoint`
2. Build `db-bootstrap` with `docker build -t odk/db-bootstrap db-bootstrap`
3. Build `openldap` with `docker build -t odk/openldap openldap`
4. Build `phpldapadmin` with `docker build -t odk/phpldapadmin phpldapadmin`

## Run

1. Tweak parameters in `ldap.env`, `sync.env`, `db.env`, `jdbc.properties`, `security.properties`, `docker-compose.yml` if needed (the default works too)  
   Note: `jdbc.properties` and `docker-compose.yml` have been configured to use PostgreSQL but MySQL is also supported. 
2. `docker stack deploy -c docker-compose.yml syncldap` to deploy all services
3. Navigate to `https://127.0.0.1:40000` and create a user, see the [LDAP](#ldap) section below for detail
4. Sync endpoint is now running at `http://127.0.0.1`

## Clean up

1. Remove the stack with, `docker stack rm syncldap`
2. Remove volumes with, `docker volume rm $(docker volume ls -f "label=com.docker.stack.namespace=syncldap" -q)`

## LDAP

The default admin account is `cn=admin,dc=example,dc=org`. The default password is `admin`, it can be changed with the `LDAP_ADMIN_PASSWORD` environment variable in `ldap.env`.

The default readonly account is `cn=readonly,dc=example,dc=org`. The defualt password is `readonly`, it can be changed with the `LDAP_READONLY_USER_PASSWORD` environment variable in `ldap.env`. This account is used by Sync endpoint to retrieve user information. 

#### Creating users

1. Login to phpLDAPAdmin as admin and create a user account under `ou=people`
2. Assign this user to groups by adding this user's `uid` as a new `memberUid` attribute to the group.

Password is required for users to log in to Sync endpoint. 

The `gidNumber` attribute is used by Sync endpoint to determine a user's default group. 

#### Creating groups

1. Login to phpLDAPAdmin as admin and create a group under `ou=default_prefix,ou=groups`
2. Assign users to this groups by adding `uid`s as `memberUid` attribute

## Notes

The OpenLDAP container is from [osixia/openldap](https://github.com/osixia/docker-openldap)

The phpLDAPadmin container is from [osixia/phpldapadmin](https://github.com/osixia/docker-phpLDAPadmin)

Refer to their respecitve documentations for usage information. 
