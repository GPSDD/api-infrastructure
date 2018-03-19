#!/bin/bash
DATE=$(date +%Y-%m-%d_%Hh%Mm)
URL_PATH=$'http://elasticsearch.default.svc.cluster.local:9200/_snapshot/data4dsgs-api-backups/'
PARAMS=$'?wait_for_completion=false'
URL=$URL_PATH$DATE$PARAMS
echo 'Uploading Elastic Backup to:'
echo $URL
curl -XPUT $URL
