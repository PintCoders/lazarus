#!/bin/bash
cd "$(dirname $0)"
source ../VARS

function stopcontainer {
  local LASTID=`sudo docker ps -q -n 1`
  sudo docker stop -t 1 $LASTID
  sudo docker rm $LASTID
  echo "STOPPED"
  exit 0
}

trap stopcontainer SIGINT SIGTERM

set -x

container_name="simple"
MASTER="raven01:8080"
APPNAME="test"
PRIVATE_IP=`ip a | grep -Po '192.168.0.1\d\d'`

if curl -s "http://$MASTER/v2/apps" | jq -r '.apps' | grep -Po "$APPNAME"; then
  LAST_APP_ID=`curl -s "http://${MASTER}/v2/apps" | jq -r ".apps[-1].id"` 
  RUNNING_INSTANCE_IP=`curl -s "http://${MASTER}/v2/apps/${LAST_APP_ID}/tasks" | jq -r '.tasks[].ipAddresses[].ipAddress'`
fi 
  
RUNNING_INSTANCE_IP=`echo "$RUNNING_INSTANCE_IP" | sed -e "s/$PRIVATE_IP//g"`
RUNNING=$(sort <<<"$RUNNING_INSTANCE_IP")
BACKUPS=$(sort <<<`ls $BACKUP_PATH`)

DEAD_CONTAINER=`comm -23 <(echo "$BACKUPS" | tr ' ' '\n') <(echo "$RUNNING" | tr ' ' "\n")`

if ! [ -z $DEAD_CONTAINER ]; then
  remote_container_id=$(sudo docker create --name simple busybox)
  #sudo docker start --checkpoint-dir=$BACKUP_PATH --checkpoint $DEAD_CONTAINER simple
  lastcontainer=`sudo docker ps -q -l -a`
  ckpdir="/var/lib/docker/containers/`sudo ls /var/lib/docker/containers/ | grep $lastcontainer`/checkpoints"
  sudo cp -r $BACKUP_PATH/$DEAD_CONTAINER $ckpdir

  sudo docker start --checkpoint $DEAD_CONTAINER simple
  #sudo rm -rf $BACKUP_PATH/$DEAD_CONTAINER
else 
  sudo docker run -d --name ${container_name} --security-opt seccomp:unconfined busybox /bin/sh -c 'i=0; while true; do echo $i; i=$((i+1)); sleep 1; done'
fi 

set +x

# sleep forever
while true; do
  sleep 1
done
