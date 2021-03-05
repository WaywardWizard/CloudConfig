
printUsergroup="print01"
user=""
password=""
installerPath="linux"
installPath="~/.papercut"
mountpoint="/mnt"

sudo mount -t cifs //$printUsergroup/PCClient -o username=$user,password=$pass $mountpoint

cp -r "$mountpoint/$installerPath/*" "$installPath"
cd "$installPath"
