#!/bin/bash
export version="arch-$(date +%Y.%m.%d)-dual.iso"
export iso_label="ARCH_$(date +%Y%m)"
export aa=$(pwd)
export customiso="$aa/customiso"
export iso=$(ls "$aa"/archlinux-* | tail -n1 | sed 's!.*/!!')
if [ ! -f /usr/bin/7z ] || [ ! -f /usr/bin/mksquashfs ] || [ ! -f /usr/bin/xorriso ] || [ ! -f /usr/bin/wget ] || [ ! -f /usr/bin/arch-chroot ] || [ ! -f /usr/bin/xxd ]; then
	if [ ! -f /usr/bin/wget ]; then query="wget"; fi
	if [ ! -f /usr/bin/xorriso ]; then query="$query libisoburn"; fi
	if [ ! -f /usr/bin/mksquashfs ]; then query="$query squashfs-tools"; fi
	if [ ! -f /usr/bin/7z ]; then query="$query p7zip" ; fi
	if [ ! -f /usr/bin/arch-chroot ]; then query="$query arch-install-scripts"; fi
	if [ ! -f /usr/bin/xxd ]; then query="$query xxd"; fi
	sudo pacman -Syy $(echo "$query")
fi
echo "teste ob neues ISO vorhanden ist..."
export archiso_link=$(lynx -dump $(lynx -dump http://arch.localmsp.org/arch/iso | grep "8\. " | awk '{print $2}') | grep "7\. " | awk '{print $2}')
if [ -z "$archiso_link" ]; then
	echo -e "ERROR: archiso link nicht gefunden"
	sleep 4
else
	iso_ver=$(<<<"$archiso_link" sed 's!.*/!!')
fi
if [ "$iso_ver" != "$iso" ]; then
	cd "$aa"
	wget "$archiso_link"
	if [ "$?" -gt "0" ]; then
		echo "Error: wget, vorhanden?"
		exit 1
	fi
	export iso=$(ls "$aa"/archlinux-* | tail -n1 | sed 's!.*/!!')
fi
init() {	
	if [ -d "$customiso" ]; then
		sudo rm -rf "$customiso"
	fi
	7z x "$iso" -o"$customiso"
	prepare_x86_64
}
prepare_x86_64() {	
	echo "Bearbeite x86_64..."
	cd "$customiso"/arch/x86_64
	sudo unsquashfs airootfs.sfs
	sudo pacman --root squashfs-root --cachedir squashfs-root/var/cache/pacman/pkg --config squashfs-root/etc/pacman.conf --noconfirm -Syyy unzip
	sudo pacman --root squashfs-root --cachedir squashfs-root/var/cache/pacman/pkg --config squashfs-root/etc/pacman.conf -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > "$customiso"/arch/pkglist.x86_64.txt
	sudo pacman --root squashfs-root --cachedir squashfs-root/var/cache/pacman/pkg --config squashfs-root/etc/pacman.conf --noconfirm -Scc
	sudo rm -f "$customiso"/arch/x86_64/squashfs-root/var/cache/pacman/pkg/*
	sudo cp "$aa"/bash_profile "$customiso"/arch/x86_64/squashfs-root/etc/skel/.bash_profile
	sudo cp "$aa"/customize.sh "$customiso"/arch/x86_64/squashfs-root/customize
	sudo arch-chroot "$customiso"/arch/x86_64/squashfs-root/ /bin/bash /customize
    sudo rm "$customiso"/arch/x86_64/squashfs-root/customize
	sudo cp "$aa"/initialise.sh "$customiso"/arch/x86_64/squashfs-root/initialise
	sudo chmod +x "$customiso"/arch/x86_64/squashfs-root/initialise
	cd "$customiso"/arch/x86_64
	rm airootfs.sfs
	echo "erstelle x86_64..."
	sudo mksquashfs squashfs-root airootfs.sfs -b 1024k -comp xz
	sudo rm -r squashfs-root
	md5sum airootfs.sfs > airootfs.md5
	prepare_i686
}
prepare_i686() {
	echo "Bearbeite i686..."
	cd "$customiso"/arch/i686
	sudo unsquashfs airootfs.sfs
	sudo setarch i686 pacman --root squashfs-root --cachedir squashfs-root/var/cache/pacman/pkg --config squashfs-root/etc/pacman.conf --noconfirm -Syyy unzip
	sudo setarch i686 pacman --root squashfs-root --cachedir squashfs-root/var/cache/pacman/pkg --config squashfs-root/etc/pacman.conf -Sl | awk '/\[installed\]$/ {print $1 "/" $2 "-" $3}' > "$customiso"/arch/pkglist.i686.txt
	sudo setarch i686 pacman --root squashfs-root --cachedir squashfs-root/var/cache/pacman/pkg --config squashfs-root/etc/pacman.conf --noconfirm -Scc
	sudo rm -f "$customiso"/arch/i686/squashfs-root/var/cache/pacman/pkg/*
	sudo cp "$aa"/bash_profile "$customiso"/arch/i686/squashfs-root/etc/skel/.bash_profile
	sudo cp "$aa"/customize.sh "$customiso"/arch/i686/squashfs-root/customize
	sudo arch-chroot "$customiso"/arch/i686/squashfs-root/ /bin/bash /customize
    sudo rm "$customiso"/arch/i686/squashfs-root/customize
	sudo cp "$aa"/initialise.sh "$customiso"/arch/i686/squashfs-root/initialise
	sudo chmod +x "$customiso"/arch/i686/squashfs-root/initialise	
	cd "$customiso"/arch/i686
	rm airootfs.sfs
	echo "erstelle i686..."
	sudo mksquashfs squashfs-root airootfs.sfs -b 1024k -comp xz
	sudo rm -r squashfs-root
	md5sum airootfs.sfs > airootfs.md5
	create_iso
}
create_iso() {
	cd "$aa"
	xorriso -as mkisofs \
	 -iso-level 3 \
	-full-iso9660-filenames \
	-volid "$iso_label" \
	-eltorito-boot isolinux/isolinux.bin \
	-eltorito-catalog isolinux/boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-isohybrid-mbr customiso/isolinux/isohdpfx.bin \
	-eltorito-alt-boot \
	-e EFI/archiso/efiboot.img \
	-no-emul-boot -isohybrid-gpt-basdat \
	-output "$version" \
	"$customiso"
}

init
