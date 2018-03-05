[![Build Status](https://travis-ci.org/Monogramm/docker-axelor-business-suite.svg)](https://travis-ci.org/Monogramm/docker-axelor-business-suite)

**This container is still in development and shouldn't be considered production ready!**

# Axelor Business Suite on Docker

Docker image for Axelor Business Suite .

## What is Axelor Business Suite  ?

Axelor Business Suite reduces the complexity and improve responsiveness of business processes. Thanks to its modularity, you can start with few features and then activate other modules when needed.

> [More informations](https://github.com/axelor/abs-webapp)

## Supported tags

https://hub.docker.com/r/monogramm/docker-axelor-business-suite/

* `4.2.3` `4.2` `4` `latest`

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

The Axelor setup wizard (should appear on first run) allows connecting to an existing MySQL/MariaDB or PostgreSQL database. You can also link a database container, e. g. `--link my-mysql:mysql`, and then use `mysql` as the database host on setup. More info is in the docker-compose section.

# Questions / Issues
If you got any questions or problems using the image, please visit our [Github Repository](https://github.com/Monogramm/docker-axelor-business-suite) and write an issue.  
