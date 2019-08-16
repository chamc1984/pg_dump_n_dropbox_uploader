#!/bin/bash

echo "shell start."
cd $(dirname $0)

DATE=$(date +%Y%m%d)
BACKUP_FILE="knowledge_backup."${DATE}".sql"
BACKUP_PATH="data/"
UPLOAD_PATH="/pg_dump/"
LOGFILE_PATH="logs/"
LOGFILE_NAME="app.log"

#
# logging function. args: $1=logmessage.
#
function logging () {

# check args
set -eu
: $1

# check logdir
if [ ! -e ${LOGFILE_PATH} ]; then
  echo "[WARN] logfilepath not exist."
  mkdir -p ${LOGFILE_PATH}
fi

# check logfile
if [ ! -e ${LOGFILE_PATH}${LOGFILE_NAME} ]; then
  echo "[WARN] logfile not exist."
  touch ${LOGFILE_PATH}${LOGFILE_NAME}
fi

# write log
echo `date +%Y/%m/%dT%H:%M:%S`" ${1}" >> ${LOGFILE_PATH}${LOGFILE_NAME}
}

#
# main logic.
#
logging "[INFO] start knowledge pg_dump."

# backup database
if [ -f ${BACKUP_PATH}${BACKUP_FILE} ]; then
  logging "[WARN] backupfile already exist. delete oldfile."
  rm ${BACKUP_PATH}${BACKUP_FILE}
fi
logging "[INFO] execute pg_dump."
pg_dump -Uknowledge knowledge -f ${BACKUP_PATH}${BACKUP_FILE}

# upload dropbox
if [ ! -f "/home/chamcwork/.dropbox_uploader" ]; then
  logging "[ERROR] uploader configfile not exist."
  exit 1
elif [ ! -f "/opt/Dropbox-Uploader/dropbox_uploader.sh" ]; then
  logging "[ERROR] uploader module not exist."
  exit 1
fi
logging "[INFO] execute dropbox_uploader.sh"
/opt/Dropbox-Uploader/dropbox_uploader.sh upload ${BACKUP_PATH}${BACKUP_FILE} ${UPLOAD_PATH}${BACKUP_FILE}
RESULT=$?
if [ ${RESULT} -ne 0 ]; then
  logging "[ERROR] upload command failed."
  exit 1
fi

# delete tmpfile
logging "[INFO] delete localfile."
rm ${BACKUP_PATH}${BACKUP_FILE}
RESULT=$?
if [ ${RESULT} -ne 0 ]; then
  logging "[ERROR] delete local backupfile failed."
  exit 1
fi

logging "[INFO] finish knowledge pg_dump."
echo "success."
exit 0

