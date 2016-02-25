# NordSec Toolkit #

A command-line utility that I made to synch firewall IP-blacklists cross multiple servers. But after some x hours time scripting it turned out to be the start of a toolkit.

* GitHub: https://github.com/nordsec/NS-Toolkit

Features
--------

Did someone say features?

* Cross-platform: Mac and Linux are officially supported.
* Written in bash

* Synch Lists/Text files cross multiple servers
* Do a complete backup of Mysql

How To Run
----------
* $ git clone https://github.com/nordsec/NS-Toolkit.git
* $ cd NS-Toolkit/
* $ chmod +x NS-Toolkit.sh
It wil ask you to create a config file, follow the promts on the way.

```
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
    1) Synch-Firewall   3) Server-Settings	5) Quit
    2) Database-Backup  4) Help
```
Configuration File
------------------
```
server1=some.hostname.or.IP
username1=Michael
blocklist1=/etc/fail2ban/blacklist

server2=some.hostname.or.IP
username2=root
blocklist2=/etc/fail2ban/blacklist

mysqlsrv=some.hostname.or.IP
mysqluser=John
backupdir=/root/mysqlbackup/
```

Support This Project
--------------------

Author
------
* Name: Alexander Nordbø
  
  Visit us at
  -----------
* https://www.hackingdefinedexperts.com
* https://github.com/nordsec/NS-Toolkit
  ```
