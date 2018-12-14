latest_failure=`curl -s 'http://raven01:8080/v2/apps//test' | jq -r '.app.lastTaskFailure.timestamp' | grep -Po '[0-9-]*T\d*:\d*:\d*' | sed 's/$/Z/g'`
latest_task=`curl -s 'http://raven01:8080/v2/apps//test' | jq -r '.app.tasks[].startedAt' | grep -Po '[0-9-]*T\d*:\d*:\d*' | sed 's/$/Z/g' | sort -r | head -n1`

latest_task_epoch=`date -d$latest_task +%s`
latest_failure_epoch=`date -d$latest_failure +%s`

echo $latest_failure $(( latest_task_epoch - latest_failure_epoch )) `curl -s 'http://raven01:5050/slaves' | jq -r '.slaves | length'`
