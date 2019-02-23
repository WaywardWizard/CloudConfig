#!/bin/bash
# # Perform a dry run if any additional argument passed

function _i { echo -e "\e[1;104m ${1}\e[0m";}	# Information
function _c { echo -e "\e[1m \$>> ${1}\e[0m";}	# Command
function _n { echo -e "\e[1m ${1}\e[0m";}		# Notice
function _g { echo -e "\e[1m ${1}\e[0m";}		# Success
function _f { echo -e "\e[1m ${1}\e[0m";}		# Failure

scriptDir="$(cd "$(dirname $BASH_SOURCE[0])" > /dev/null && pwd)/"

# Make a command inert if dry run. Print the command if inert
function dryer {
	if [ -z "$dry" ]
	then
		eval "$@"
	else
		_c "$@"
	fi
}

# Make command inert quietly
function quietDryer {
	dryer "$@" > /dev/null
}

# Copy lines from files in source directory to files of same name in target directory
# whenever those lines are not already present in the target directory files. Preserve ordering.
#
# $1 - absolute source directory 
# $2 - absolute target directory
#
function installConfig {

	([ ${1#/} != $1 ] && [ ! -z $1 ]) || (echo "installConfig: Must get absolute source - got $1" && exit);
	([ ${2#/} != $2 ] && [ ! -z $2 ]) || (echo "installConfig: Must get absolute target - got $2" && exit);
	targetDir="${2%/}/"
	sourceDir="${1%/}/"

	echo "Transferring configuration from $sourceDir to $targetDir"

	# Process configuration files in source folder. 
	for cfgFile in $(find -L ${sourceDir} -maxdepth 1 -type f)
	do

		echo "Processing configuration file $cfgFile"

		targetFile="${targetDir}$(basename $cfgFile)"

		# Create the cfg if missing
		if ! [ -a "$targetFile" ]
		then
			_i "Creating config file $targetFile"
			touch "$targetFile"
		fi

		# Add missing configuration lines to srcCfgFilename 
		while read line
		do
			if [[ ! "$line" =~ ^\ *$ ]] # Silence empty lines
			then

				_i "Adding line: "
				(dryer tee -a "$targetFile")<<<"$line" 
			else
				quietDryer tee -a "$targetFile" "<<<$line"
			fi

		done <<< "$(diff --changed-group-format='%<' --unchanged-group-format='' $cfgFile $targetFile  )" # Whatever lines are not there
	done
}
# CloudConfig
function run {

	# Dry run if any additional argument passed
	if [ ! -z "$1" ]
	then
		dry=true
		_i "This is a dry run"
	fi


	_i "Installing configuration"
	installConfig "${scriptDir}home" $HOME
	_i "Done..."
}

run "$@"
