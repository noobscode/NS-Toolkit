#!/bin/bash
function header {
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
# 	- This is a Really handy script to merge multiple
#	  blacklists cross multiple servers for fail2ban or any other firewall.
#
#	- Its also possible to make a complete backup of Mysql.
#
# 	Created by Alexander Nordbø on the 23.02.2016
# 	                Visit us at
#		https://www.hackingdefinedexperts.com
#		https://github.com/nordsec/NS-Toolkit
EOF
}
header
function srvconfig {
read -p "        Run Config? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Creating config file, please wait...";
sleep 1

#id=1; You can use server ID if you like.

# Server 1
read -p " Whats the Server1 Hostname or IP?   :" server1;
read -p " Whats the Server1 Username?   :" username1;
read -p " Write the full dir to list (/etc/fail2ban/blacklist)   :" blocklist1;

# Server 2
read -p " Whats the Server2 Hostname or IP?   :" server2;
read -p " Whats the Server2 Username?   :" username2;
read -p " Write the full dir to list (/etc/fail2ban/blacklist)   :" blocklist2;
#read -p " Optional Directory on server2   :" opdir2;

# Mysql
read -p " Whats the Mysql's Hostname?   :" mysqlsrv;
read -p " What is the username for Mysql?   :" mysqluser;
read -p " Tell Mysql where to store backups of the database   :" backupdir;
echo "Good job!, Now give us a seck while we build the config and send you of to the toolbox"
sleep 3

printf '' "# This is the configuration file for NS-Toolkit. Feel free to edit manually #" '' > config_file
printf '%s\n' "server1${id}=${server1}" "username1${id}=${username1}" "blocklist1${id}=${blocklist1}" '' >> config_file
printf '%s\n' "server2${id}=${server2}" "username2${id}=${username2}" "blocklist2${id}=${blocklist2}" '' >> config_file
printf '%s\n' "mysqlsrv${id}=${mysqlsrv}" "mysqluser${id}=${mysqluser}" "backupdir${id}=${backupdir}" '' >> config_file

echo "Configuration completed succsessfully! Press [Enter] to continue"; read -r
clear;
else
  echo "Press [Enter] to continue to menu"; read -r
clear;
fi
}
srvconfig
# shellcheck disable=SC1091
source config_file

header

  OPTIONS="Synch-Firewall Database-Backup Server-Settings Help Quit"
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

	#[[ -f ./${sname} ]] && read -p "File exists. Are you sure? " -n 1
	#[[ ! $REPLY =~ ^[Yy]$ ]] && return 1
	srvconfig



	elif [ "$opt" = "Help" ]; then
	echo "Visit: https://github.com/nordsec/NS-Toolkit"

	elif [ "$opt" = "Quit" ]; then
	exit
	else

	echo "Bad option"

fi
done
