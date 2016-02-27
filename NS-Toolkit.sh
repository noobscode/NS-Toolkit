#!/bin/bash
# shellcheck disable=SC1091
source functions
header

if [ "$TOS" = "OK" ]; then
srvconfig

else
echo "Run ./setup.sh first!"
fi
# shellcheck disable=SC1091
source config_file
header
echo
  OPTIONS="Synch-Firewall Database-Backup Server-Settings Update Help Quit"
select opt in $OPTIONS; do

########### Database-Backup ###############

        if [ "$opt" = "Database-Backup" ]; then
        echo Backing up Mysql
# Simple command to backup entire mysql #

	mysqldump --user=$mysqluser -p --host=$mysqlsrv --all-databases > $backupdir"dump-$( date '+%Y-%m-%d_%H-%M-%S' ).sql"
	exit

############## Synch-Firewall Blocklists ##############

	elif [ "$opt" = "Synch-Firewall" ]; then
	echo "Synching Firewall Now"
	echo "Copying blocklist from server 1"
# Move the list of blocked ip's from server 1 to server 2#
	scp $blocklist1 $username2'@'$server2:/tmp/ip.blocklist.list1

	echo "merging the blocklists"
#Now ssh in to server 2 and add blocked ip from server 1 the to blocklist on server 2#
	ssh $username2'@'$server2 "
		mv $blocklist2 /tmp/ip.blocklist.list2
		cat /tmp/ip.blocklist.list1 /tmp/ip.blocklist.list2 > $blocklist2
	echo "Cleaning up"
		rm /tmp/ip.*
	echo "restarting services"
		sudo /etc/init.d/fail2ban restart "
sleep 3
	echo "Running the list back to server #1"
# Now we send the full list back to server 1 again#
	ssh $username2'@'$server2 "
sleep 2; echo "Connecting to server, please wait..."
	scp $blocklist2 $username1'@'$server1:/tmp/ip.blocklist.list2 "

# And merge the file again #
		mv $blocklist1 /tmp/ip.blocklist.list1
		cat /tmp/ip.blocklist.list1 /tmp/ip.blocklist.list2 > /tmp/sort.list
	echo "Removing Duplicates from Blacklist1"
		awk '!a[$0]++' /tmp/sort.list >	$blocklist1
	echo "Cleaning up files NOW"
		rm /tmp/ip.* /tmp/sort.list
		sudo /etc/init.d/fail2ban restart

	elif [ "$opt" = "Server-Settings" ]; then
	reconfig

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
