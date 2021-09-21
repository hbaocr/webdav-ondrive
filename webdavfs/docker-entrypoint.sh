#!/bin/bash

if [ ! -f "/etc/davfs2/davfs2.conf" ]
then 
     touch /etc/davfs2/davfs2.conf
fi

chmod 777 /etc/davfs2/davfs2.conf
echo >> /etc/davfs2/davfs2.conf
echo >> /etc/davfs2/davfs2.conf

OD4B=${ONEDRIVE_URL:-""}
MPATH=${WEBDAV_MOUT:-/webdavfs/mnt}
USERNAME=${USERNAME:-"default-user"}
PASSWORD=${PASSWORD:-"this-is-secrete"}

mkdir -p $MPATH

echo "Remove Lockfile webdavfs-mnt.pid to make sure webdav can start "
rm -rf /var/run/mount.davfs/webdavfs-mnt.pid


# Check variables and defaults
if [ -z "${ONEDRIVE_URL}" ]; then
    echo "No URL specified! please set ONEDRIVE_URL env "
    exit
fi

if [ -z "${USERNAME}" ]; then
    echo "No USERNAME specified! please set USERNAME env "
    exit
fi

if [ -z "${PASSWORD}" ]; then
    echo "No PASSWORD specified! please set PASSWORD env "
    exit
fi


#wget https://raw.githubusercontent.com/yulahuyed/test/master/get-sharepoint-auth-cookie.py
python3 get-sharepoint-auth-cookie.py ${OD4B} ${USERNAME} ${PASSWORD} > cookie.txt
sed -i "s/ //g" cookie.txt
COOKIE=$(cat cookie.txt)
DAVFS_CONFIG=$(grep -i "use_locks 0" /etc/davfs2/davfs2.conf)
if [ "${DAVFS_CONFIG}" == "use_locks 0" ] 
then
  echo "continue..."
else
  echo "use_locks 0" >> /etc/davfs2/davfs2.conf
fi

echo >> /etc/davfs2/davfs2.conf
echo >> /etc/davfs2/davfs2.conf

echo "[${MPATH}]" >> /etc/davfs2/davfs2.conf
echo "ask_auth 0" >> /etc/davfs2/davfs2.conf
echo "add_header Cookie ${COOKIE}" >> /etc/davfs2/davfs2.conf

rm cookie.txt #get-sharepoint-auth-cookie.py

mount.davfs ${OD4B} ${MPATH}

if [ -n "$(ls -1A $MPATH)" ]; then
    echo "Mounted $ONEDRIVE_URL onto $MPATH"
    exec "$@"
else
    echo "Nothing found in $MPATH, giving up!"
fi

