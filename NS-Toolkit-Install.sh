#!/bin/bash

inst="git"

echo "SSH is required for the toolkit to work"

read -p "Start SSH? (yes/no) " ans
if [ "$ans" = "YES" ]; then

sudo apt-get update
sudo apt-get install $inst -y
else
echo "okei then, just trying to help"
fi

cd /usr/share/
echo -n "Downloading Toolbox,"; slepp 1;echo " Adding a Hammer,"; sleep 1 echo "screw driver and a cat?"
git clone https://github.com/nordsec/NS-Toolkit.git
cd NS-Toolkit/
chmod +x NS-Toolkit.sh

#echo "Creating shortcut"

#touch /usr/bin/nstoolkit
#chmod +x /usr/bin/nstoolkit
#cat #!/bin/bash > /usr/bin/nstoolkit
#cat cd /usr/share/nstoolkit/ && ./NS-Toolkit > /usr/bin/nstoolkit

exit
