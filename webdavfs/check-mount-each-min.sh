PERIOD=${1:-60}
DEST=${WEBDAV_MOUT:-/webdavfs/mnt}

while true; do
    echo "check mout webdav sync file : ${DEST}"
    ls $DEST
    sleep $PERIOD
done