# Assignment: Docker Compose

## Background
[Docker Compose](https://docs.docker.com/compose/) is a tool for defining and running multi-container Docker applications. 
With compose, you can configure different services in a single configuration file and have them all start up with a single
simple command. 

## Prerequisites
Docker Desktop is installed

## Instructions
### Read the Docker Compose Overview at https://docs.docker.com/compose/. 

### Update the docker-compose.yml 
In the previous assignments you created volumes for `postgis` and `geoserver` containers. Open the [docker-compose.yml](docker-compose.yml) file in this repo and update the appropriate volumes sections so that you can re-use these volumes.

### Create a special network for these containers
We will create a network that our containers will run inside and that will give us the ability to connect new containers to the same network without going through all the ordeal of the --link and environment variables that we did for previous labs:
```
docker network create gist604b
```

### Kill and remove old containers
You had previously run `kartoza/geoserver` and `mdillon/postgis` with the docker cli. We need to clean those containers up
before we start docker compose. Get a listing of all the containers:
```
docker container ls 
```
will list the containers running. To see also stopped containers:
```
docker container ls -a
```
Output will look something like this:
```
(base) null-island:hawaii-latest-free.shp aaryno$ docker container ls -a
CONTAINER ID        IMAGE                         COMMAND                   CREATED             STATUS                       PORTS                              NAMES
44d6ab42af74        kartoza/geoserver             "/bin/sh /scripts/en…"    6 hours ago         Up About an hour             0.0.0.0:8180->8080/tcp, 8443/tcp   geoserver
9aef61bd6d24        fe2443655f26                  "/bin/sh -c /populat…"    7 hours ago         Exited (126) 7 hours ago                                        naughty_blackburn
b69e91c52a9a        mdillon/postgis               "sh -c 'psql -h \"$PO…"   8 hours ago         Created                      5432/tcp                           amazing_swirles
81b2dc969bfc        mdillon/postgis               "docker-entrypoint.s…"    8 hours ago         Created                                                         postgis
b26a0721aec5        mdillon/postgis               "docker-entrypoint.s…"    8 hours ago         Up About an hour             0.0.0.0:25432->5432/tcp             docker-compose-postgis-geoserver_postgis_1
04a912394e68        aaryno/jupyter-geo            "jupyter notebook --…"    46 hours ago        Exited (0) 46 hours ago                                         sharp_wu
```
You can remove the `postgis` container like this:
```
docker stop postgis
docker rm postgis
docker stop geoserver
docker rm geoserver
...
docker stop ... # Anything running that you want to stop
docker rm ... # Anything stopped you want to remove
...
```
You can remove others (you will have to prune this space eventually if you use docker enough) but it's the named `postgis` that we really **need** to remove stop and remove now. We are going to start a new postgis container and if it is mounting and writing to the same directory at the same time then we are almost guaranteed to have data corruption issues.

### Run `docker-compose up`
_Caveat: `docker-compose` must run from the directory in which `docker-compose.yml` is or else provide the full path to the docker-compose by specifying `-f <path to docker-compose.yml>`_

To start the services:
```
docker-compose up
```
Output from the geoserver and postgis containers will start being output to the terminal. Now you can access them through the local ports of `8080` and `5432` respectively.

To shut them down, you can CTRL+C or close the window.

If you want to run the services in `detached` mode, you can add `-d` to the command, which would allow you to close the window and it would still be running:
```
docker-compose up -d
```
And you would shut it down with:
```
docker-compose down
```

### Optional: Import OSM data from Delaware
I wrote a utility that will create a new database, download the OSM shapefiles from geofabrik.de, and populate the database with the shapefile data. This is essentially what you did in a previous lab but here it is in a script inside a docker container that you can run in a single line:
```
docker run --network gist604b -e STATE=delaware -e DATABASE=delaware aaryno/populate-docker-webgis populate-postgis.sh
```

### Deliverables:

The following file in a branch named `compose`, submitted as a Pull Request to be merged with master:
1) Screenshot named `compose_screenshot.png` showing output of shell running `docker compose up`

