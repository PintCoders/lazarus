#!/bin/bash
cd "$(dirname $0)"

source ../VARS
TICK=5

PRIVATE_IP=`ip a | grep -Po '192.168.0.1\d\d'`

while true; do
  if docker ps -n1 | grep simple; then
    set -x
    #sudo docker checkpoint rm simple $PRIVATE_IP

    #sudo docker network disconnect bridge simple
    #sleep 5
    cp -rf "/var/lib/docker/containers/`docker inspect simple | jq -r '.[].Id'`/checkpoints/$PRIVATE_IP"{,.back}
    rm -rf "/var/lib/docker/containers/`docker inspect simple | jq -r '.[].Id'`/checkpoints/$PRIVATE_IP" 
    if ! sudo docker checkpoint create --leave-running=true simple $PRIVATE_IP; then
    #if ! sudo docker checkpoint create simple $PRIVATE_IP; then
      cp -rf "/var/lib/docker/containers/`docker inspect simple | jq -r '.[].Id'`/checkpoints/$PRIVATE_IP".back "/var/lib/docker/containers/`docker inspect simple | jq -r '.[].Id'`/checkpoints/$PRIVATE_IP"
    fi

    #sudo docker start --checkpoint $PRIVATE_IP simple 
    #sudo docker network connect bridge simple
    #sleep 1
    #sync
    cp -rf "/var/lib/docker/containers/`docker inspect simple | jq -r '.[].Id'`/checkpoints/$PRIVATE_IP" $BACKUP_PATH
    set +x
  fi
  sleep $TICK
done
