# Bacula on Docker

## Introduction

This is a working technology preview of running Bacula (Open Source) 7.4.0 in
multiple [Docker](https://www.docker.com/) containers.

To make it easier to get started a `docker-compose.yml` is provided and it's
assumed that `docker-compose` is used to start the containers. For actual
deployment the `docker` binary ought to be used directly (e.g. by starting
the containers as a service).

## Images

The images are available on the [Docker Hub](https://hub.docker.com/) as:
- [redcoolbeans/bacula-opensource-db-data](https://hub.docker.com/r/redcoolbeans/bacula-opensource-db-data/)
- [redcoolbeans/bacula-opensource-db](https://hub.docker.com/r/redcoolbeans/bacula-opensource-db/)
- [redcoolbeans/bacula-opensource-dir](https://hub.docker.com/r/redcoolbeans/bacula-opensource-dir/)
- [redcoolbeans/bacula-opensource-sd](https://hub.docker.com/r/redcoolbeans/bacula-opensource-sd/)
- [redcoolbeans/bacula-opensource-fd](https://hub.docker.com/r/redcoolbeans/bacula-opensource-fd/)

## Requirements

The following components are required for this setup:

- Docker >= 1.9.0
- Docker Compose >= 1.5.0

Instructions on how to install these on for example CentOS, can be found
[here](http://docs.docker.com/engine/installation/centos/) and [here](https://docs.docker.com/compose/install/).
Please note that the Docker version shipped with CentOS 7 is too old and cannot be used.

### Networking

This setup uses the networking features of Docker, therefore `docker-compose`
needs to be invoked with the `--x-networking` flag. The remainder of this document
assumes that a shell alias has been setup to shrink repeated shell commands:

    alias docker-compose='docker-compose --x-networking'

The local network that will be created is named after the directory the `docker-compose.yml`
file is located in. E.g. if the full path is `/home/bat/docker/bacula` then the network will
be named `bacula` and this can be verified (after `docker-compose up`) with `docker network ls`.

## Starting the setup

Then fetch the images:

	docker-compose pull

When this has succesfully completed you can start the containers:

	docker-compose up

This will spawn five containers, which can be verified with `docker ps`:

- *bacula-db-data*: data volume container; will not actually run but provide a persistent storage
- *bacula-db*: PostgreSQL container, using storage provided by `bacula-db-data`
- *bacula-dir*: Bacula Director container
- *bacula-sd*: Bacula Storage Daemon container
- *bacula-fd*: Bacula File Daemon (client) container

docker-compose will run in the foreground and multiplex the container's output to the
controlling terminal. To run all containers in the background:

    docker-compose start

To stop all containers one can simple hit `^C` if they run in the foreground, or when running the background:

    docker-compose stop

## Configuration

### Bacula

Configuration files are stored in `$PWD/configs/{dir,sd}/` relative to the
directory this README file is located.
The `dir`/`sd` directories are mounted read-only into the container to
`/opt/bacula/etc/`

In order to apply new configuration the associated container has to be
restarted. For example:

	docker-compose restart bacula-dir

### Docker

There are several options which can be modified in `docker-compose.yml`.
Changing their values does require either a `docker-compose restart $CONTAINER`,
or a full restart of the setup if that's prefered (`docker-compose `).
The most common options:

- BACULA_DEBUG: defaults to `50`
- mem\_limit: limit the available memory the container is allowed to use. Size is memory + swap, in bytes.

## bconsole

bconsole can be invoked from outside of the container:

    docker exec -ti bacula-dir bconsole

## Bacula client

A Bacula client container is started which runs the client daemon. The following environment
variables are used to configure it's `bacula-fd.conf`:

- FD_NAME
- FD_PASSWORD
- DIR_NAME
- MON_NAME
- MON_FD_PASSWORD

Of which only `FD_PASSWORD` _must_ be set, the others have default values.

## Support

These images are provided free of charge by RedCoolBeans. Various security measures
have not been implemented or added in these images.
For supported and security hardened images with Bacula Enterprise, please
[contact us](http://www.redcoolbeans.com/contact/).

## Caveats

- upgrades between Bacula versions is not yet accounted for
- e-mail notifications are not enabled in the default configuration shipped with
  this demonstration setup. If e-mail is desired it can be enabled and pointed to
  an existing mailhost.
- Mounting a local `bacula-fd.conf` into the `bacula-fd` container is not supported
  yet. Due to the limited configuration possible in this file it is advised to set
  the documented environment variables for now.
