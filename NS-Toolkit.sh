#!/bin/bash

#################################################
#						#
#		NS-Toolkit			#
#						#
#	Author: Alexander Nordbø		#
#	Mail: alexander@nordsec.no		#
#						#
#	Date: 27.02.2016			#
#						#
#	https://www.github.com/nordsec		#
#################################################

# shellcheck disable=SC1091
source functions

if [ "$TOS" = "OK" ]; then
echo "Setup: OK!"
else
echo "Run ./setup.sh first!"
exit
fi
if [ "$CF" = "OK" ]; then
echo "Config: OK!"
else
echo "Run ./setup.sh first!"
exit
fi

if [ ! -f config_file ]; then
srvconfig
else
mainmen
fi
exit
