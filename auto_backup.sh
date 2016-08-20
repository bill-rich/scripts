#!/bin/bash

while true; do
	inotifywait -r -qq -e close_write,delete --exclude '\..+' @/home/amanda/Downloads @/home/amanda/server /home/amanda/
	rsync --delete -aq --exclude ".*" --exclude "server/*" /home/amanda 192.168.10.6:/media/storage/archive/Documents/amanda_backup
done
