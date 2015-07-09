#!/bin/bash

echo "Setting up data only container..."
docker run -d \
  -v /configuration \
  -v /profiles \
  -v /home/steam/mpmissions \
  -v /home/steam/mods \
  --name data-arma3 --entrypoint /bin/echo \
  adamveld12/arma3 \
  "Arma 3 data-only container"

echo "Running server container..."
docker run -td \
  -p 2302-2305:2302-2305/udp \
  -p 2344-2345:2344-2345/udp -p 2344-2345:2344-2345/tcp \
  -p 8766:8766/udp -p 27016:27016/udp \
  -p 2222:22 \
  --volumes-from data-arma3 \
  adamveld12/arma3
