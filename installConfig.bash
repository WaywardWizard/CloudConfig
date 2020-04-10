#!/bin/bash
# # Perform a dry run if any additional argument passed
set -e

function _i { echo -e "\e[1;104m ${1}\e[0m";}	# Information
function _c { echo -e "\e[1m \$>> ${1}\e[0m";}	# Command
function _n { echo -e "\e[1m ${1}\e[0m";}		# Notice
function _s { echo -e "\e[1m ${1}\e[0m";}		# Success
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
# Where there are folders in the source directory, copy their content to a folder of the same 
# name in the target directory. 
#
# $1 - absolute source directory 
# $2 - absolute target directory
#
function installConfig {

	([ ${1#/} != $1 ] && [ ! -z $1 ]) || (_f "installConfig: Must get absolute source - got $1" && exit);
	([ ${2#/} != $2 ] && [ ! -z $2 ]) || (_f "installConfig: Must get absolute target - got $2" && exit);
	targetDir="${2%/}/"
	sourceDir="${1%/}/"

    if [ ! -e "$targetDir" ];then dryer mkdir "$targetDir";fi

	_i "Transferring configuration from $sourceDir to $targetDir"

	# Process configuration files in source folder. 
	for cfgFile in $(find -L ${sourceDir} -maxdepth 1 -type f)
	do

		_i "Processing configuration file $cfgFile"

		targetFile="${targetDir}$(basename $cfgFile)"

        # Remove target config file if clobber set
        if [ $clobber = "true" -a -e "$targetFile" ]; then
            dryer "rm $targetFile"
        fi

		if ! [ -a "$targetFile" ]
		then
			_i "Creating config file $targetFile"
			quietDryer touch "$targetFile"
        fi

        # Add missing configuration lines to srcCfgFilename. -r will ignore backslashes (making text literal) 
        IFS_OLD=$IFS
        IFS="" # No trimming of whitespace and read whole line into field
		while read -r line
		do
			if [[ ! "$line" =~ ^\ *$ ]] # Silence empty lines
			then
				(dryer tee -a "$targetFile")<<<"$line"
			else
                (quietDryer tee -a "$targetFile")<<<"$line"
			fi

		done <<<"$(diff --changed-group-format='%<' --unchanged-group-format='' $cfgFile $targetFile )"
        IFS=$IFS_OLD
        # No expansion post substitution. 

	done

    # Process folders in the source folder (recursively)
    for cfgFolder in $(find -L ${sourceDir} -maxdepth 1 -mindepth 1 \( -type l -o -type d \))
    do
        _i "Processing configuration folder '$cfgFolder'"
        targetFolder="$2/$(basename $cfgFolder)"
        if [ ! -e "$targetFolder" ]; then dryer mkdir $targetFolder;fi
        installConfig "$cfgFolder" "$targetFolder" #Recurse
    done
}

function run {

	# Dry run if any additional argument passed
	if [ ! -z "$1" ]
	then
		dry=true
		_i "This is a dry run"
	fi

    clobber=""
    if [ ! -z "$2" ]
    then
        _i "This shall clobber configuration instead of add to it"
        clobber="true"
    fi

	_i "Installing configuration"
	installConfig "${scriptDir}home" $HOME
	_i "Done..."
}

run "$@"
