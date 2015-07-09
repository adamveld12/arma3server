#!/bin/bash
docker run -it \
  -p 2302-2305:2302-2305/udp \
  -p 2344-2345:2344-2345/udp -p 2344-2345:2344-2345/tcp \
  -p 8766:8766/udp -p 27016:27016/udp \
  -p 2222:22 \
  -v $PWD/configuration:/configuration \
  -v $PWD/profiles:/profiles \
  adamveld12/arma3 
  /bin/bash
