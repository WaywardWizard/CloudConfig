#!/bin/bash
#
# Perform a dry run if any additional argument passed

function _i {; echo -e "\e[1;104m ${1}";}	# Information
function _c {; echo -e "\e[1m \$>> ${1}";}	# Command
function _n {; echo -e "\e[1m ${1};}		# Notice
function _g {; echo -3 "\e[1m ${1};}		# Success
function _f {; echo -3 "\e[1m ${1};}		# Failure

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

# Installs to calling users ~/.config, every line of every file 
# in thisRepo/.config that is not already present. 
#
# Existing lines of files in ~/.config will not be changed.
# Where a line already exists in ~/.config/* it will be ignored
function installConfig {
	# Process configuration srcCfgFilenames
	for srcCfgFilename in $(ls -A .config)
	do
		cfgPath="${HOME}/${srcCfgFilename}"
		srcPath=".config/${srcCfgFilename}"

		# Create the cfg if missing
		if [ ! -a "$cfgPath" ]
		then
			_i "Creating config $cfgPath"
			dryer touch "$cfgPath"
		fi

		# Add missing configuration lines to srcCfgFilename 
		while read line
		do
			# Only if not present already
			if [[ ! $(grep -x "$line" "$cfgPath") ]] 
			then
				if [[ ! "$line" =~ ^\ *$ ]]
				then
					_i -n "Adding line: "
					dryer tee -a "$cfgPath" "<<<" "'$line'"
				else
					quietDryer tee -a "$cfgPath" "<<<" "'$line'"
				fi	
			fi
		done < "$srcPath"
	done
}

function run {

	# Dry run if any additional argument passed
	if [ ! -z "$1" ]
	then
		dry=true
		_i "This is a dry run"
	fi


	_i "Installing configuration"
	installConfig
	installBashProfile
	_i "Done..."
}

		
function installBashrc {
	# Relative to the directory of this script
	scriptDirectory="bashrc"
	for script in ${BASH_SOURCE[0]})/${scriptDirectory}/*
	do
		tee -a ~/.bashrc <<< "source $script"
	done
}
