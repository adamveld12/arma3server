#!/bin/bash
set -eou pipefail

dataAlias="data-arma3"
echo -n "data container name [defaults to data-arma3]:"
read dataAlias


if [[ $dataAlias == "" ]]; then
  dataAlias="data-arma3"
fi

if [[ ! -z $(docker ps -a | grep "$dataAlias") ]]; then
  answer=""
  echo "Would you like to overwrite the existing data container of the same name [y for yes, or anything for no] "
  read answer
  if [[ $answer == "y" ]]; then 
    docker rm $dataAlias
  else 
    exit
  fi
fi

docker run -d \
  -v /configuration \
  -v /profiles \
  -v /home/steam/mpmissions \
  -v /home/steam/mods \
  --name $dataAlias --entrypoint /bin/echo \
  adamveld12/arma3 \
  "Arma 3 data-only container"

if [[ -z $(docker ps | grep "adamveld12/arma3") ]]; then
  docker run -td \
    -p 2302-2305:2302-2305/udp \
    -p 2344-2345:2344-2345/udp -p 2344-2345:2344-2345/tcp \
    -p 8766:8766/udp -p 27016:27016/udp \
    -p 2222:22 \
    --volumes-from $dataAlias \
    adamveld12/arma3
else
  echo "server container already running"
fi
