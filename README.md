[![Build Status](https://travis-ci.org/Monogramm/docker-axelor-business-suite.svg)](https://travis-ci.org/Monogramm/docker-axelor-business-suite)

**This container is still in development and shouldn't be considered production ready!**

# Axelor Business Suite on Docker

Docker image for Axelor Business Suite .

## What is Axelor Business Suite  ?

Axelor Business Suite reduces the complexity and improve responsiveness of business processes. Thanks to its modularity, you can start with few features and then activate other modules when needed.

> [More informations](https://github.com/axelor/abs-webapp)

## Supported tags

https://hub.docker.com/r/monogramm/docker-axelor-business-suite/

* `4.2.3-jre8` `4.2.3` `4.2-jre8` `4.2` `4-jre8` `4` `latest`
* `4.2.3-jre8-alpine` `4.2.3-alpine` `4.2-jre8-alpine` `4.2-alpine` `4-jre8-alpine` `4-alpine` `alpine`

## How to run this image ?

This image is based on the [officiel Tomcat repository](https://hub.docker.com/_/tomcat/).

This image does not contain the database for Axelor. You need to use either an existing database or a database container.

This image is designed to be used in a micro-service environment.

## Using docker
The image contains an application server and exposes port 8080 and 8443. To start the container type:

```console
$ docker run -d -p 8080:8080 monogramm/docker-axelor-business-suite
```

Now you can access Axelor at http://localhost:8080/ from your host system.

## Using an external database
By default this container does not contain the database for Axelor. You need to use either an existing database or a database container.

## Persistent data
The Axelor installation and all data beyond what lives in the database (file uploads, etc) are stored in [unnamed docker volume](https://docs.docker.com/engine/tutorials/dockervolumes/#adding-a-data-volume) volume `/srv/axelor`. The docker daemon will store that data within the docker directory `/var/lib/docker/volumes/...`. That means your data is saved even if the container crashes, is stopped or deleted.

To make your data persistent to upgrading and get access for backups is using named docker volume or mount a host folder. To achieve this you need one volume for your database container and Axelor.

Axelor:
- `/srv/axelor/` folder where all Axelor data lives
```console
$ docker run -d \
    -v axelor_html:/srv/axelor/ \
    monogramm/docker-axelor-business-suite
```

Database:
- `/var/lib/postgresql/data` PostgreSQL Data
- `/var/lib/mysql` MySQL / MariaDB Data
```console
$ docker run -d \
    -v db:/var/lib/postgresql/data \
    postgres
```

If you want to get fine grained access to your individual files, you can mount additional volumes for config, your uploads and other. 

Overview of the folders that can be mounted as volumes:

- `/srv/axelor/config` configuration which will be copied to ABS app on startup
- `/srv/axelor/upload` ABS uploaded documents

If you want to use named volumes for all of these it would look like this
```console
$ docker run -d \
    -v config:/srv/axelor/config \
    -v upload:/srv/axelor/upload \
    monogramm/docker-axelor-business-suite
```

## Auto configuration via configuration file

You can provide a fully setup up `application.properties` and joining it in your config volume
```console
$ mkdir -p /srv/axelor/config
$ cp ./application.properties /srv/axelor/config/application.properties
$ docker run -d \
    -v /srv/axelor/config:/srv/axelor/config \
    monogramm/docker-axelor-business-suite
```

The application config will be copied to Axelor's config location before running tomcat.

## Auto configuration via environment variables

The Axelor image supports auto configuration via environment variables. You can preconfigure nearly everything that is needed to run Axelor. The generated configuration will be stored in `/srv/axelor/config`, which can be mounted as a volume to later modify the default config.

See following links for more details on configuration:
* [Application Configuration](http://docs.axelor.com/adk/latest/dev_guide/application/config.html)
* [application.properties](https://github.com/axelor/abs-webapp/blob/master/src/main/resources/application.properties)


### DB_URL

*Default value*: `postgresql://localhost:5432/axelor-business-suite`

This parameter contains the name of the driver used to access your Axelor database.

Examples:
```
DB_URL=postgresql://postgre.domain.com:5432/axelordb
DB_URL=mysql://192.168.0.11:3306/myaxelordb
```

### DB_USER

*Default value*: 

This parameter contains user name used to read and write into Axelor database.

Examples:
```
DB_USER=admin
DB_USER=axeloruser
```

### DB_PASSWORD

*Default value*: 

This parameter contains password used to read and write into Axelor database.

Examples:
```
DB_PASSWORD=myadminpass
DB_PASSWORD=myuserpassword
```

### DB_DRIVER

*Default value*: `org.postgresql.Driver`

Database dialect used to generate SQL queries by Hibernate.
Depends on database type used.

Examples:
```
DB_DRIVER=org.postgresql.Driver
DB_DRIVER=com.mysql.jdbc.Driver
```

### DB_DIALECT

*Default value*: `org.hibernate.dialect.PostgreSQLDialect`

Database dialect used to generate SQL queries by Hibernate.
Depends on database driver used. In most cases Hibernate will actually be able to choose the correct dialect implementation based on the JDBC metadata returned by the JDBC driver.
See [Hibernate SQL Dialects](https://docs.jboss.org/hibernate/orm/3.5/reference/en/html/session-configuration.html#configuration-optional-dialects) for more details.

Examples:
```
DB_DIALECT=org.hibernate.dialect.PostgreSQLDialect
DB_DIALECT=org.hibernate.dialect.MySQL5InnoDBDialect
```


### HOME

*Default value*: `http://localhost:8080`

This parameter defines the link to be used with header logo.

Examples:
```
HOME=http://localhost
HOME=http://myaxelorvirtualhost
HOME=http://myserver/axelor
HOME=http://myserver/axeloralias
```

### LOCALE

*Default value*: `en`

*Possible values*: any i8n code available in the [translations](https://github.com/axelor/abs-webapp/tree/master/src/main/resources/i18n)

This parameter defines the locale to be used by Axelor.

Examples:
```
LOCALE=en
LOCALE=fr
```

### THEME

*Default value*: `theme-default`

*Possible values*: any theme name available in the [css](https://github.com/axelor/abs-webapp/tree/master/src/main/webapp/css) folder

This parameter defines the theme to be used by Axelor.

Examples:
```
THEME=theme-default
THEME=theme-blue
THEME=theme-red
THEME=theme-green
THEME=theme-dark-green
THEME=theme-grey
```

### MODE

*Default value*: `prod`

*Possible values*: `dev` for development mode, else `prod`

This parameter defines the application mode.

Examples:
```
MODE=dev
MODE=prod
```

### DEMO

*Default value*: `false`

*Possible values*: `false` or `true`

This parameter defines whether to import demo data for the application.

Examples:
```
DEMO=false
DEMO=true
```

### DATE_FORMAT

*Default value*: `yyyy-MM-dd`

This parameter defines date time format used by Axelor to display dates.

Examples:
```
DATE_FORMAT=yyyy-MM-dd
DATE_FORMAT=dd/MM/yyyy
DATE_FORMAT=MM/dd/yyyy
```

### TIMEZONE

*Default value*: `UTC`

This parameter defines the timezone for Axelor.

Examples:
```
TIMEZONE=UTC
TIMEZONE=Europe/Paris
```


### LDAP_AUTH_TYPE

*Default value*: `axelor`

*Possible values*: `simple` or `CRAM-MD5`

This parameter contains the way authentication is done.

Examples:
```
LDAP_AUTH_TYPE=simple
LDAP_AUTH_TYPE=CRAM-MD5
```


### LDAP_URL

*Default value*: 

You can define several servers here separated with a comma.

Examples:
```
LDAP_URL=ldap://localhost:389
LDAP_URL=ldaps://ldap.company.com:636
```

### LDAP_ADMIN_LOGIN

*Default value*: 

Required only if anonymous bind disabled.

Examples:
```
LDAP_ADMIN_LOGIN=cn=admin,dc=company,dc=com
```

### LDAP_ADMIN_PASS

*Default value*: 

Required only if anonymous bind disabled. Ex: 

Examples:
```
LDAP_ADMIN_PASS=secret
```

### LDAP_USER_BASE

*Default value*: 

Examples:
```
LDAP_USER_BASE=ou=People,dc=company,dc=com
```

### LDAP_USER_FILTER

*Default value*: `(uid={0})`

Examples:
```
LDAP_USER_FILTER=(uid={0})
LDAP_USER_FILTER=(&(uid={0})(isMemberOf=cn=Sales,ou=Groups,dc=company,dc=com))
```

### LDAP_GROUP_BASE

*Default value*: 

Examples:
```
LDAP_GROUP_BASE=ou=Groups,dc=company,dc=com
```

### LDAP_GROUP_FILTER

*Default value*: `(uniqueMember=uid={0})`

Examples:
```
LDAP_GROUP_FILTER=(uniqueMember=uid={0})
```

### LDAP_GROUP_CLASS

*Default value*: 

Examples:
```
LDAP_GROUP_CLASS=groupOfUniqueNames
```


### SMTP_HOST

*Default value*: 

Examples:
```
SMTP_HOST=smtp.gmail.com
```

### SMTP_PORT

*Default value*: 

Examples:
```
SMTP_PORT=587
```

### SMTP_CHANNEL

*Default value*: 

Examples:
```
SMTP_CHANNEL=starttls
```

### SMTP_USER_NAME

*Default value*: 

Examples:
```
SMTP_USER_NAME=user@gmail.com
```

### SMTP_PASSWORD

*Default value*: 

Examples:
```
SMTP_PASSWORD=secret
```


### IMAP_HOST

*Default value*: 

Examples:
```
IMAP_HOST=imap.gmail.com
```

### IMAP_PORT

*Default value*: 

Examples:
```
IMAP_PORT=993
IMAP_PORT=25
```

### IMAP_CHANNEL

*Default value*: 

Examples:
```
IMAP_CHANNEL=ssl
IMAP_CHANNEL=starttls
```

### IMAP_USER_NAME

*Default value*: 

Examples:
```
IMAP_USER_NAME=user@gmail.com
```

### IMAP_PASSWORD

*Default value*: 

Examples:
```
IMAP_PASSWORD=secret
```


# Running this image with docker-compose

## Base version - JRE8 with PostgreSQL
This version will use the jre8 image and add a [PostgreSQL](https://hub.docker.com/_/postgre/). The volumes are set to keep your data persistent. This setup provides **no ssl encryption** and is intended to run behind a proxy.

Make sure to set the variables `POSTGRES_PASSWORD` and `DB_PASSWORD` before you run this setup.

Create `docker-compose.yml` file as following:

```yml
version: '2'

volumes:
  axelor_up:
  axelor_db:

postgres:
    image: postgres:latest
    restart: always
    environment:
        - "POSTGRES_DB=axelor"
        - "POSTGRES_USER=axelor"
        - "POSTGRES_PASSWORD="
    volumes:
        - axelor_db:/var/lib/postgresql/data

axelor:
    image: monogramm/docker-axelor-business-suite
    depends_on:
        - postgres
    ports:
        - "8080:8080"
        - "8443:8443"
    environment:
        - "DB_URL=postgresql://postgres:5432/axelor"
        - "DB_USER=axelor"
        - "DB_PASSWORD="
    volumes:
        - axelor_up:/srv/axelor/upload
```

Then run all services `docker-compose up -d`. Now, go to http://localhost:8080 to access the new Axelor installation.

## Base version - Alpine with MariaDB/MySQL
This version will use the alpine image and add a [MariaDB](https://hub.docker.com/_/mariadb/) container (you can also use [MySQL](https://hub.docker.com/_/mysql/) if you prefer). The volumes are set to keep your data persistent. This setup provides **no ssl encryption** and is intended to run behind a proxy. 

Make sure to set the variables `MYSQL_ROOT_PASSWORD` and `DB_PASSWORD` before you run this setup.

Create `docker-compose.yml` file as following:

```yml
version: '2'

volumes:
  axelor_config:
  axelor_up:
  axelor_db:

mariadb:
    image: mariadb:latest
    restart: always
    volumes:
      - axelor_db:/var/lib/mysql
    environment:
        - "MYSQL_ROOT_PASSWORD="
        - "MYSQL_DATABASE=axelor"

axelor:
    image: monogramm/docker-axelor-business-suite:alpine
    restart: always
    depends_on:
        - mariadb
    ports:
        - "8080:8080"
        - "8443:8443"
    environment:
        - "DB_DRIVER=com.mysql.jdbc.Driver"
        - "DB_URL=mysql://mariadb:3306/axelor"
        - "DB_USER=root"
        - "DB_PASSWORD="
    volumes:
        - axelor_config:/srv/axelor/config
        - axelor_up:/srv/axelor/upload
```

Then run all services `docker-compose up -d`. Now, go to http://localhost:8080 to access the new Axelor installation.


# Make your Axelor available from the internet
Until here your Axelor is just available from you docker host. If you want you Axelor available from the internet adding SSL encryption is mandatory.

## HTTPS - SSL encryption
There are many different possibilities to introduce encryption depending on your setup. 

We recommend using a reverse proxy in front of our Axelor installation. Your Axelor will only be reachable through the proxy, which encrypts all traffic to the clients. You can mount your manually generated certificates to the proxy or use a fully automated solution, which generates and renews the certificates for you.


# Update to a newer version
Updating the Axelor container is done by pulling the new image, throwing away the old container and starting the new one. Since all data is stored in volumes, nothing gets lost. Don't forget to add all the volumes to your new container, so it works as expected. Also, we advise you to not skip major versions during your upgrade. For instance, upgrade from 4.0 to 4.1, then 4.1 to 4.2, not directly from 4.0 to 4.2.

```console
$ docker pull monogramm/docker-axelor-business-suite
$ docker stop <your_axelor_container>
$ docker rm <your_axelor_container>
$ docker run <OPTIONS> -d monogramm/docker-axelor-business-suite
```
Beware that you have to run the same command with the options that you used to initially start your Axelor. That includes volumes, port mapping.

When using docker-compose your compose file takes care of your configuration, so you just have to run:

```console
$ docker-compose pull
$ docker-compose up -d
```


# Adding Features
If the image does not include the packages you need, you can easily build your own image on top of it.
Start your derived image with the `FROM` statement and add whatever you like.

```yaml
FROM monogramm/docker-axelor-business-suite

RUN ...

```

You can also clone this repository and use the [update.sh](update.sh) shell script to generate a new Dockerfile based on your own needs.

For instance, you could build a container based on Axelor master branch by setting the `update.sh` versions like this:
```bash
versions=( "master" )
```
Then simply call [update.sh](update.sh) script.

```console
bash update.sh
```
Your Dockerfile(s) will be generated in the `images/master` folder.

If you use your own Dockerfile you need to configure your docker-compose file accordingly. Switch out the `image` option with `build`. You have to specify the path to your Dockerfile. (in the example it's in the same directory next to the docker-compose file)

```yaml
  app:
    build: .
    links:
      - db
    volumes:
      - config:/srv/axelor/config
      - upload:/srv/axelor/upload
    restart: always
```

**Updating** your own derived image is also very simple. When a new version of the Axelor image is available run:

```console
docker build -t your-name --pull . 
docker run -d your-name
```

or for docker-compose:
```console
docker-compose build --pull
docker-compose up -d
```

The `--pull` option tells docker to look for new versions of the base image. Then the build instructions inside your `Dockerfile` are run on top of the new image.

# Questions / Issues
If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-axelor-business-suite) and write an issue.  
