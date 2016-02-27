#!/bin/bash
# shellcheck disable=SC1091
source functions
header

#if [ "TOS" = $OK ]; then
#echo "Good 2 Go"

#else
#echo "Run ./setup.sh first!"
#fi

srvconfig
# shellcheck disable=SC1091
source config_file

function mainmen {
header
echo
  OPTIONS="Synch-Firewall Database-Backup Settings Update Help Quit"
select opt in $OPTIONS; do

        if [ "$opt" = "Database-Backup" ]; then
	mysqlbackup

	elif [ "$opt" = "Synch-Firewall" ]; then
	fsynch

	elif [ "$opt" = "Settings" ]; then
	clear	
	submen

	elif [ "$opt" = "Update" ]; then
	kitupdate

	elif [ "$opt" = "Help" ]; then
	echo "Visit: https://github.com/nordsec/NS-Toolkit"
	cat README.md
	elif [ "$opt" = "Quit" ]; then
	exit
	else

	echo "Bad option"

fi
done
}

function submen {
	header	
	OPTIONS2="Edit-Config"
	select opt in $OPTIONS2; do
if [ "$opt" = "Edit-Config" ]; then
	nano /usr/share/config_file
fi
done
}



























