#!/bin/bash
#
# Perform a dry run if any additional argument passed

echo "Installing configuration"

function dryer {
	if [ -z "$dry" ]
	then
		eval "$@"
	else
		echo "$@"
	fi
}

function quietDryer {
	dryer "$@" > /dev/null
}

# Dry run if any additional argument passed
if [ ! -z "$1" ]
then
	dry=true
	echo "Dry run $dry"
fi

# Process configuration srcCfgFilenames
for srcCfgFilename in $(ls -A .config)
do
	cfgPath="${HOME}/${srcCfgFilename}"
	srcPath=".config/${srcCfgFilename}"

	# Create the cfg if missing
	if [ ! -a "$cfgPath" ]
	then
		echo "Creating config $cfgPath"
		dryer touch "$cfgPath"
	fi

	# Add missing configuration lines to srcCfgFilename
	while read line
	do
		if [[ ! $(grep -x "$line" "$cfgPath") ]] 
		then
			if [[ ! "$line" =~ ^\ *$ ]]
			then
				echo -n "Adding line: "
				dryer tee -a "$cfgPath" "<<<" "'$line'"
			else
				quietDryer tee -a "$cfgPath" "<<<" "'$line'"
			fi	
		fi
	done < "$srcPath"
done
		
echo "Done..."
