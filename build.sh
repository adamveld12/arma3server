#!/bin/bash
name="adamveld12/arma3"

if [[ -f "./keys/id_rsa"  && -f "./keys/id_rsa.pub" ]]; then
  echo "Using existing keypair..."
else
  echo -n "Your ssh password (leave blank for no password) [ENTER]:"
  read -e sshpass
  echo -e "Generating key pair for SSH in ./keys..."
  rm -rf ./keys
  mkdir ./keys
  ssh-keygen -b 4096 -N "${sshpass}" -f ./keys/id_rsa -C "Arma 3 Admin Server Key" &> /dev/null
fi

echo -e "Building container as \"${name}\"..."
docker build -t ${name} .

if [[ -f $(which boot2docker) ]]; then
  IP=$(boot2docker ip)
else
  IP=127.0.0.1
fi

echo "${name} completed."
echo "to ssh into your new server run:"
echo "ssh root@${IP} -i ./keys/id_rsa -p 2222"

