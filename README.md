# CloudConfig
Generic configuration for linux distributions


# Shell Setup
SDDM runs Xsetup and Xsession found in /usr/share/sddm/scripts
These scripts source files like ~/.bash_profile and ~/.profile

## .bash_profile is run interactive login shells
## .bashrc is run for interactive non login shells
## /etc/profile systemwide login initialization
This also runs shell scripts in /etc/profile.d
Scripts in /etc/profile.d are systemwide configurations
