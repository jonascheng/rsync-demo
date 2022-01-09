#!/bin/bash

OS="$(uname -s)"

case "${OS}" in
    Darwin*)    HOSTIP=`ipconfig getifaddr en0`;;
    *)          HOSTIP=`hostname --ip-address`;;
esac

SYNC_PATH=/home/vagrant/shared
DST_PATH=/home/vagrant

# ignore this script
[[ ${2} == "$(basename -- ${0})" ]] && exit
# ignore file *.log
[[ ${2} == *.log ]] && exit
# ignore file .*
[[ ${2} == .* ]] && exit
# ignore empty and null
[ ${2} == "" ] && FILE="NULL" || FILE=${2}

echo "$(date "+%H:%M:%S.%3N") OnInotifyReceived ${1}, ${2}, ${3}" >> '/var/log/rsync.log' 2>&1

for dst_server in 10.1.0.10 10.1.0.20 10.1.0.30
do
  if [ ${dst_server} != ${HOSTIP} ]; then
    # Rsync Options Summary
    # -g, --group preserve group
    # -o, --owner preserve owner (super-user only)
    # -p, --perms preserve permissions
    # -r, --recursive recurse into directories
    # -t, --times preserve modification times
    # -v, --verbose increase verbosity
    # -z, --compress compress file data during the transfer
    echo "$(date "+%H:%M:%S.%3N") CMD /usr/bin/rsync -vzrtopg --delete --progress ${1}/${2} ${dst_server}:${1}" >> '/var/log/rsync.log' 2>&1
    # /usr/bin/rsync -vzrtopg --delete --progress --exclude '.*' ${SYNC_PATH} ${dst_server}:${DST_PATH}
    /usr/bin/rsync -vzrtopg --delete --progress ${1}/${2} ${dst_server}:${1}
    echo "$(date "+%H:%M:%S.%3N") SYNCED ${dst_server}, ${FILE}" >> '/var/log/rsync.log' 2>&1
  fi
done
