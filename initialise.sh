# !/bin/sh
WIFI_DEV=$(ip link | awk '{print $2}' | grep -i "wl" | sed 's/://')
ether_connect() {
	if [[ $(systemctl status dhcpcd | grep "running") == "" ]]; then
		systemctl enable dhcpcd
		systemctl start dhcpcd
	fi
	dialog --title " Verbinde Netzwerk " --infobox "\nBitte warten..." 0 0 && sleep 5
}
wifi_connect() {
	if [[ $(systemctl status dhcpcd | grep "running") != "" ]]; then
		systemctl disable dhcpcd
		systemctl stop dhcpcd
	fi
	ip link set $WIFI_DEV down >/dev/null 2>&1	
	clear
	wifi-menu
	dialog --title " Verbinde Wireless " --infobox "\nBitte warten..." 0 0 && sleep 2
}
download_aif() {
	clear
	wget -N https://github.com/montygood/monty/tarball/master -O - | tar xz
	cd montygood*
	sh inst.sh
}
dialog --title " Netzwerk Verbindung " --infobox "\nBitte warten..." 0 0 && sleep 8
while [[ ! $(ping -c 1 google.com) ]]; do
	dialog --title " Netzwerk Verbindung " --menu $"Bitte wählen" 0 0 3 \
	"1" $"Netzwerk" \
	"2" $"Wireless" \
	"3" $"Beenden" 2>/tmp/.opt
	case $(cat /tmp/.opt) in
	"1") ether_connect 
		;;
	"2") if [[ $WIFI_DEV != "" ]]; then
			wifi_connect
		 else
			dialog --title " Netzwerk Error " --msgbox "\nkeine Wirelesskarte gefunden" 0 0
		 fi
		;;
	 *) break
		exit 1
		;;
	esac
done
[[ $(ping -c 1 google.com) ]] && download_aif
