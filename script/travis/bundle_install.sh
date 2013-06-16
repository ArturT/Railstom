#!/bin/sh

ARCHITECTURE=`uname -m`
FILE_NAME="$BUNDLE_ARCHIVE-$ARCHITECTURE.tgz"

cd ~
wget -O "remote_$FILE_NAME" "http://$CI_FTP_URL/$FILE_NAME" && tar -xf "remote_$FILE_NAME"
wget -O "remote_$FILE_NAME.sha2" "http://$CI_FTP_URL/$FILE_NAME.sha2"

exit 0
