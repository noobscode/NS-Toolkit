#!/bin/bash
cat << "EOF"
#  _    _               _
# | |  | |             | |
# | |__| |  __ _   ___ | | __ ___  _ __  ___
# |  __  | / _` | / __|| |/ // _ \| '__|/ __|
# | |  | || (_| || (__ |   <|  __/| |   \__ \
# |_|  |_| \__,_| \___||_|\_\\___||_|   |___/
#
# A simple script to compine multiple blacklists cross servers for fail2ban or any other firewall.
# Feel free to edit
# Created by Alexander Nordbø on the 23.02.2016
# Visit us at https://www.hackingdefinedexperts.com"

EOF
############# Config ##############
# Firewall-Synch #

server1=""
username1=""
blacklist1="/etc/fail2ban/ip.blocklist.list"
opdir=""

server2=""
username2=""
blocklist2="/etc/fail2ban/ip.blocklist.list"

# Mysql #

mysqlsrv=""
mysqluser=""
# (uncomment to specify, else promt mysqlpasswd="")
###################################

########### Database-Backup ###############
OPTIONS="Synch-Firewall Database-Backup Exit"
select opt in $OPTIONS; do

        if [ "$opt" = "Database-Backup" ]; then
        echo Backing up Mysql
# Simple command to backup entire mysql #

mysqldump --user=$mysqluser -p --host=$mysqlsrv --all-databases > "/root/mysqlbackup/dump-$( date '+%Y-%m-%d_%H-%M-%S' ).sql"

exit;
############## Synch-Firewall Blacklists ##############
#
#
	if [ "$opt" = "Synch-Firewall" ]; then
	echo Synching Firewall Now
	echo Copying blacklist from server #1
# Move the list of blocked ip's from server 1 to server 2#
	scp $blacklist1 $username2'@'$server2:/tmp/ip.blocklist.list1

	echo merging the blacklists
#Now ssh in to server 2 and add blocked ip from server 1 the to blocklist on server 2#
	ssh $username2'@'$server2 "
		mv $blocklist2 /tmp/ip.blocklist.list2;
		cat /tmp/ip.blocklist.list1 /tmp/ip.blocklist.list2 > /etc/fail2ban/ip.blocklist.list;
		echo Cleaning up
		rm /tmp/*;
		echo restarting services
		sudo /etc/init.d/fail2ban restart;

		echo Running the list back to server #1
# Now we send the full list back to server 1 again#
	scp $blocklist2 $username1'@'$server1:$opdir ip.blocklist.list
exit;
"
# And merge the file again #
		mv $opdir ip.blocklist.list /tmp/ip.blocklist.list1 && mv /etc/fail2ban/ip.blocklist.list /tmp/ip.blocklist.list2;
		cat /tmp/ip.blocklist.list1 /tmp/ip.blocklist.list2 > /etc/fail2ban/ip.blocklist.list;
		echo Cleaning up files NOW
		rm /tmp/ip.*;
		sudo /etc/init.d/fail2ban restart;
fi
exit;
#done

    elif [ "$opt" = "Exit" ]; then
                echo 'done'
                exit;


fi
done
