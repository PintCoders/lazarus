#!/bin/bash
cd "$(dirname $0)"

source ../VARS
TICK=10

PRIVATE_IP=`ip a | grep -Po '192.168.0.1\d\d'`

while true; do
  if docker ps -n1 | grep simple; then
    set -x
    sudo docker checkpoint rm simple $PRIVATE_IP
    rm -rf "/var/lib/docker/containers/`docker inspect simple | jq -r '.[].Id'`/checkpoints/$PRIVATE_IP" 
    sudo docker checkpoint create --leave-running=true simple $PRIVATE_IP
    sleep 1
    sync
    cp -rf "/var/lib/docker/containers/`docker inspect simple | jq -r '.[].Id'`/checkpoints/$PRIVATE_IP" $BACKUP_PATH
    set +x
  fi
  sleep $TICK
done
