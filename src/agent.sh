#!/bin/bash

MASTER="raven01:8080"
DFS='hadoop dfs '

RUNNING_INSTANCE=`curl -s "http://${MASTER}/v2/apps/test1122/tasks" | jq -r '.tasks[].id'`
BACKUP=`$DFS -ls /backups 2>&1 | grep "^d[rwx-]\{0,9\}t\?\s" | awk '{ print $8; }'`

echo $RUNNING_INSTANCE
echo $BACKUP

if [ -z $BACKUP ]; then
  echo "Fresh running"
  bash -c 'docker run -t ubuntu /bin/bash'
  exit 0
fi 

$DFS -copyToLocal /backups/$RUNNING_INSTANCE ./img

# RUNcommand to launch CRUI IMAGE
echo "Running from backup"
