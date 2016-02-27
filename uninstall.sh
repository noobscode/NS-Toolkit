#!/bin/bash

read -r -p " This will remove NS-Toolkit, Are you sure? " ans
if [ "$ans" = "yes" ]; then
echo "Uninstalling NS-Toolkit"
sleep 1


rm -fr /usr/share/NS-Toolkit
rm /usr/bin/nstoolkit
echo "DONE!"
sleep 1
fi
