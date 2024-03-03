#!/bin/bash

### file path ###
PRM_PATH=/var/lib/prometheus/node-exporter
TMP_FILE=${PRM_PATH}/mh_z19.prom.tmp
PRM_FILE=${PRM_PATH}/mh_z19.prom

### collect co2 value ###
i=0
while [ $i -le 10 ]
do
  sleep 1
  VALUE=`python -m mh_z19 | jq .[]`
  if [ -z $VALUE ]; then
    ((i++))
    echo "co2 value is null. retry $i"
  else
    echo "co2 value is $VALUE"
    break
  fi
done

### put prom file ###
echo "mh_z19_co2 $VALUE" > $TMP_FILE
echo "mh_z19_co2_retry $i" >> $TMP_FILE
mv $TMP_FILE $PRM_FILE
exit
