#!/bin/bash
TARGET_HOST="bendesktop.local"
_usage () {
	echo "$0 <remote_dbpath> <local_dbpath> <host>"
	echo "Sync local db <dbpath> with remote db on <host>"
}

if [ -z "$1" -o -z "$2" -o -z "$3" ];then
	_usage
	exit
fi

TARGET_HOST="$3"
remoteFilePath="$1"
localFilePath="$2"

scp "$TARGET_HOST:$remoteFilePath" __Passwords.kdbx
if [ ! -d "$(dirname $localFilePath)/old" ];then
	mkdir "$(dirname $localFilePath)/old"
	cp "$localFilePath" "$(dirname $localFilePath)/old"
fi
keepassxc-cli merge -s "$localFilePath" __Passwords.kdbx 
