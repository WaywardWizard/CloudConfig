#!/bin/bash

printUsage(){
    echo <<< "
    Usage: ./keepassBackup <kpFolder> <kpSyncFolder> <frequency [min]>

    Action:
    Installs a systemd timer to update the kp database by merging any *.kpdb
    files using of same name between two given folders. 

    Dependancy:
    kpcli
    "
}

