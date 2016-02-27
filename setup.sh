#!/bin/bash
# shellcheck disable=SC1091
source functions

inst="git"
dir="/usr/share/NS-Toolkit"

echo "SSH is required for the toolkit to work"

read -r -p "Start SSH? (yes/no) " ans
if [ "$ans" = "yes" ]; then

sudo service ssh start
else
echo "okei then, just trying to help"
fi

echo "Installing dependencies"
sudo apt-get -y --force-yes install $inst -q

if [ -d "$dir" ]; then
read -r -p "NS-Toolkit is already installed, would you like to reinstall? (yes/no)" ans
fi

if [ "$ans" = "yes" ]; then

rm -rf /usr/share/NS-Toolkit
rm /usr/bin/nstoolkit

nsinst
fi

if [ ! -d "$dir" ]; then
nsinst

fi
exit
