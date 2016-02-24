#!/bin/bash
cat << "EOF"

#    _   _  _____   _______          _ _    _ _
#   | \ | |/ ____| |__   __|        | | |  (_) |
#   |  \| | (___      | | ___   ___ | | | ___| |_
#   | . ` |\___ \     | |/ _ \ / _ \| | |/ / | __|
#   | |\  |____) |    | | (_) | (_) | |   <| | |_
#   |_| \_|_____/     |_|\___/ \___/|_|_|\_\_|\__|
#
#		Welcome To NordSec Toolkit!
#
# 	- This is simple script to merge multiple
#	  blacklists cross multiple servers for fail2ban or any other firewall.
#
#	- Make a complete backup of Mysql.
#
# Created by Alexander Nordbø on the 23.02.2016
# Visit us at https://www.hackingdefinedexperts.com"
#
EOF

function srvconfig {
read -p "        Run Config? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Creating config file, please wait...";
	echo "Hostname or IP for server1"; read 
sleep 3
else
  echo "Press [Enter] to continue to menu"; read
fi
}
srvconfig
############# Config ##############
# Firewall-Synch #

srv1=""
usr1=""
bl1="/etc/fail2ban/ip.blocklist.list"

srv2="db01.isp.nordsec.no"
usr2="root"
bl2="/etc/fail2ban/ip.blocklist.list"
opdir="/home/alexander/"
# Mysql #

mysqlsrv="db01.isp.nordsec.no"
mysqluser="Alexander"
#mysqlpasswd=""
###########################################

  OPTIONS="Synch-Firewall Database-Backup Server-Settings Help Quit"
select opt in $OPTIONS; do

########### Database-Backup ###############

        if [ "$opt" = "Database-Backup" ]; then
        echo Backing up Mysql
# Simple command to backup entire mysql #

	mysqldump --user=$mysqluser -p --host=$mysqlsrv --all-databases > "/root/mysqlbackup/dump-$( date '+%Y-%m-%d_%H-%M-%S' ).sql"
	exit
############## Synch-Firewall Blocklists ##############

	elif [ "$opt" = "Synch-Firewall" ]; then
	echo "Synching Firewall Now"
	echo "Copying blocklist from server 1"
# Move the list of blocked ip's from server 1 to server 2#
	scp $blocklist1 $usr2'@'$srv2:/tmp/ip.blocklist.list1

	echo "merging the blocklists"
#Now ssh in to server 2 and add blocked ip from server 1 the to blocklist on server 2#
	ssh $username2'@'$server2 "
		mv $blocklist2 /tmp/ip.blocklist.list2
		cat /tmp/ip.blocklist.list1 /tmp/ip.blocklist.list2 > /etc/fail2ban/ip.blocklist.list
	echo "Cleaning up"
		rm /tmp/*
	echo "restarting services"
		sudo /etc/init.d/fail2ban restart "

	echo "Running the list back to server #1"
# Now we send the full list back to server 1 again#
	ssh $username2'@'$server2 "
	scp $blocklist2 $username1'@'$server1:$opdir "

# And merge the file again #
		mv /home/alexander/ip.blocklist.list /tmp/ip.blocklist.list1
		mv /etc/fail2ban/ip.blocklist.list /tmp/ip.blocklist.list2
		cat /tmp/ip.blocklist.list1 /tmp/ip.blocklist.list2 > $blocklist1
	echo "Cleaning up files NOW"
		rm /tmp/ip.*
		sudo /etc/init.d/fail2ban restart

	elif [ "$opt" = "Server-Settings" ]; then
	
	[[ -f ./${sname} ]] && read -p "File exists. Are you sure? " -n 1
	[[ ! $REPLY =~ ^[Yy]$ ]] && return 1
	srvconfig



	elif [ "$opt" = "Help" ]; then
	echo "Visit: www.hackingdefinedexperts.com/scripts"

	elif [ "$opt" = "Quit" ]; then
	exit
	else

	echo "Bad option"

fi
done
