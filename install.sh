#!/bin/bash

# Relative to the directory of this script
scriptDirectory="configScripts"

for script in $(dirname ${BASH_SOURCE[0]})/${scriptDirectory}/*
do
	tee -a ~/.bashrc <<< "source $script"
done
