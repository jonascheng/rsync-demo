#!/bin/bash

OS="$(uname -s)"

case "${OS}" in
    Darwin*)    HOSTIP=`ipconfig getifaddr en0`;;
    *)          HOSTIP=`hostname --ip-address`;;
esac

SYNC_PATH=/home/vagrant/shared
DST_PATH=/home/vagrant

# ignore IN_IGNORED event
[[ ${3} == "IN_IGNORED" ]] && exit 0
# ignore this script
[[ ${2} == "$(basename -- ${0})" ]] && exit 0
# ignore file *.log
[[ ${2} == *.log ]] && exit 0
# ignore file .*
[[ ${2} == .* ]] && exit 0
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
    echo "$(date "+%H:%M:%S.%3N") CMD /usr/bin/rsync -vzrtopg --delete --exclude '.*' --password-file=/etc/secret --progress ${SYNC_PATH}/ root@${dst_server}::Rsync" >> '/var/log/rsync.log' 2>&1
    /usr/bin/rsync -vzrtopg --delete --exclude '.*' --password-file=/etc/secret --progress ${SYNC_PATH}/ root@${dst_server}::Rsync
    echo "$(date "+%H:%M:%S.%3N") SYNCED ${dst_server}, ${FILE}" >> '/var/log/rsync.log' 2>&1
  fi
done
