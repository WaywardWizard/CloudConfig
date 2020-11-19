#!/bin/bash
md5sumd () {
	for f in "$1"; do echo "$(find "$f" -type f -exec md5sum '{}' \;|awk '{print $1}'|sort|md5sum|cut -f1 -d' ')" "$f";done
}
