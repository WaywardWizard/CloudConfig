#!/bin/bash
# # Perform a dry run if any additional argument passed
set -e

function _i { echo -e "\e[1;104m ${1}\e[0m";}	# Information
function _c { echo -e "\e[1m \$>> ${1}\e[0m";}	# Command
function _n { echo -e "\e[1m ${1}\e[0m";}		# Notice
function _s { echo -e "\e[1m ${1}\e[0m";}		# Success
function _f { echo -e "\e[1m ${1}\e[0m";}		# Failure

scriptDir="$(cd "$(dirname $BASH_SOURCE[0])" > /dev/null && pwd)/"

declare -i DRY_RUN=1
declare -i CLOBBER=0

# Make a command inert if dry run. Print the command if inert
function dryer {
	if (( $DRY_RUN ))
	then
		_c "$@"
	else
		eval "$@"
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
# $3 - owner of file in target location. Default to calling user
function installConfig {

	([ ${1#/} != $1 ] && [ ! -z $1 ]) || (_f "installConfig: Must get absolute source - got $1" && exit);
	([ ${2#/} != $2 ] && [ ! -z $2 ]) || (_f "installConfig: Must get absolute target - got $2" && exit);
	selectedUser=${3:-$USER}

	targetDir="${2%/}/"
	sourceDir="${1%/}/"

    if [ ! -e "$targetDir" ];then dryer mkdir "$targetDir";fi

	_i "Transferring configuration from $sourceDir to $targetDir"

	# Process configuration files in source folder. 
	for cfgFile in $(find -L ${sourceDir} -maxdepth 1 \( -type f -o -xtype l \) )
	do

		_i "Processing configuration file $cfgFile"

		targetFile="${targetDir}$(basename $cfgFile)"

        # Remove target config file if clobber set
	    if (( CLOBBER )) && [[ -e "$targetFile" ]]; then
            dryer "sudo rm $targetFile"
        fi

		if ! [ -a "$targetFile" ]
		then
			_i "Creating config file $targetFile"
			quietDryer sudo -u $selectedUser touch "$targetFile"
        fi

        # Add missing configuration lines to srcCfgFilename. -r will ignore backslashes (making text literal) 
        IFS_OLD=$IFS
        IFS="" # No trimming of whitespace and read whole line into field
		while read -r line
		do
			if [[ ! "$line" =~ ^\ *$ ]] # Silence empty lines
			then
				(dryer sudo -u $selectedUser tee -a "$targetFile")<<<"$line"
			else
                (quietDryer sudo -u $selectedUser tee -a "$targetFile")<<<"$line"
			fi

		done <<<"$(sudo -u $selectedUser diff --changed-group-format='%<' --unchanged-group-format='' $cfgFile $targetFile )"
        IFS=$IFS_OLD
        # No expansion post substitution. 

	done

    # Process folders in the source folder (recursively)
    for cfgFolder in $(find -L ${sourceDir} -maxdepth 1 -mindepth 1 \( -type l -o -type d \))
    do
        _i "Processing configuration folder '$cfgFolder'"
        targetFolder="$2/$(basename $cfgFolder)"
        if [ ! -e "$targetFolder" ]; then dryer mkdir $targetFolder;fi
        installConfig "$cfgFolder" "$targetFolder" $3 #Recurse
    done
}

function run {

	# Dry run if any additional argument passed
	(( DRY_RUN )) && _i "This is a dry run"
	(( CLOBBER )) || _i "This shall add to configuration instead of clobber it"

	_i "Installing configuration"
	installConfig "${scriptDir}home" "$HOME"
	installConfig "${scriptDir}etc" "/etc" root
	installConfig "${scriptDir}home-root" "/root" root
	_i "Done..."
}

function help {
	cat <<- eof
	Updates user config directory to be as per cloud config.

	Usage: 
	$0 [ -a -c -b -i ]

	Args:
	-a dont dry run
	-c clobber config dont update 
	-b install scripts
	-i install config
	eof
}

function installScripts {
	if [[ ! -e ${HOME}/bin ]];then
		mkdir ${HOME}/bin
	fi
	for s in "${scriptDir}"scripts/bin/*;do
		if [[ -e ${HOME}/bin/"$(basename $s)" ]];then
			rm ${HOME}/bin/"$(basename $s)"
		fi
		ln -s $s ${HOME}/bin/
	done

    _addPath "${HOME}/bin"
    export PATH

}

function _addPath() {
    IFS=: read -r -a line <<< $PATH 
    for path in ${line[@]};do
        if [[ $path == $1 ]];then
            return 1
        fi
    done
    PATH="$PATH:$1"
}

while getopts ":acbi" opt;do
	case $opt in
		a )
			DRY_RUN=0
			;;
		c )
			CLOBBER=1
			;;
		s ) 
			installScripts
			exit $?
			;;
		i ) 
		    run "$@"
		    exit $?
		    ;;
		* )
			help
			exit 1
			;;
	esac
done

# When no options given
if [[ $OPTIND==0 ]];then
    help
    exit 1
fi