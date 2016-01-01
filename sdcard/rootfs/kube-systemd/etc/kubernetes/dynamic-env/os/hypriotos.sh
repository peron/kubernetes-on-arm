os_install(){

	# Update the system and use pacman to install all the packages
	# The two commands may be combined, but I leave it as is for now.
	os_upgrade
	
	# Since docker and git is installed by default, we have nothing more to do here

	# If brctl isn't installed, install it
	if [[ ! -f $(which brctl 2>&1) ]]; then
		apt-get install bridge-utils -y
	fi
}


os_upgrade(){
	echo "Upgrading packages..."
	apt-get update -y && apt-get upgrade -y
}

os_post_install(){
	# Reflect the new hostname in /boot/occidentalis
	newhostname=$(hostnamectl | grep hostname | awk '{print $3}')
	sed -i "/hostname=/c\hostname=$newhostname" /boot/occidentalis.txt

	# Write the DNS options to the file
	cat >> /etc/dhcp/dhclient.conf <<EOF 
prepend domain-search "default.svc.cluster.local","svc.cluster.local","cluster.local";
prepend domain-name-servers 10.0.0.10;
EOF

}