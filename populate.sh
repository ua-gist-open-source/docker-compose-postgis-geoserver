#!/bin/bash

STATE=hawaii
DATABASE=hawaii
HOST=postgis
PORT=5432
USER=postgres

while [ $# -gt 0 ]; do
	if [[ $1 == '-d' ]] && [[ $# -gt 1 ]]
	then
		DATABASE=$2
		shift
		shift
	elif [[ $1 == '--state' ]] && [[ $# -gt 1 ]]; then
		STATE=$2
		shift
		shift
	elif [[ $1 == '-h' ]] && [[ $# -gt 1 ]]; then 
		HOST=$2
		shift
		shift
	elif [[ $1 == '-U' ]] && [[ $# -gt 1 ]]; then
		USER=$2
		shift
		shift
	elif [[ $1 == '-p' ]] && [[ $# -gt 1 ]] ; then
		PORT=$2
		shift
		shift
	else
		echo "Unknown option: $1"
		exit 1
	fi
done

curl http://download.geofabrik.de/north-america/us/${STATE}-latest-free.shp.zip -o ${STATE}-latest-free.shp.zip

# Unzip
mkdir ${STATE}-latest-free.shp
unzip ${STATE}-latest-free.shp.zip -d ${STATE}-latest-free.shp

x=$(ls $OUT_DIR/${STATE}-latest-free.shp/*.shp | cut -f6 -d/ | sed 's/gis_osm_//' | sed 's/_free_1.shp//' | awk '{ print "gis_osm_" $1 "_free_1.shp:" $1 }')
for ft in $x; do
  f=$(echo $ft | cut -f1 -d:)
  t=$(echo $ft | cut -f2 -d: | sed 's/natural/nature/g')
  shp2pgsql -s 4326 -c -g geom ${STATE}-latest-free.shp/$f public.$t | psql -h $HOST -p $PORT -U $USER -d $DATABASE
done