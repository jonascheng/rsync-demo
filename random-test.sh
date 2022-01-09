#!/bin/bash

OS="$(uname -s)"

case "${OS}" in
    Darwin*)    HOSTIP=`ipconfig getifaddr en0`;;
    *)          HOSTIP=`hostname --ip-address`;;
esac

SYNC_FILE=/home/vagrant/shared/random-test.txt

counter=0
while true; do
  echo "${counter}: Press [CTRL+C] to stop.."
  echo "$(date "+%H:%M:%S.%3N") ${counter}:${HOSTIP}" >> ${SYNC_FILE} 2>&1
  sleep $[ ( $RANDOM % 3 ) + 1 ]s
  counter=$((counter+1))
done
