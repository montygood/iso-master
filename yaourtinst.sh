DIR="/tmp"
yaourt -S pamac-aur --noconfirm --needed --export $DIR
yaourt -S aic94xx-firmware --noconfirm --export $DIR
yaourt -S wd719x-firmware --noconfirm --export $DIR
yaourt -S mint-x-icons --noconfirm --export $DIR
yaourt -S mint-x-theme --noconfirm --export $DIR
yaourt -S wakeonlan --noconfirm --export $DIR
yaourt -S mp3gain --noconfirm --export $DIR && cp /usr/bin/mp3gain $DIR
yaourt -S mediaelch --noconfirm --export $DIR
yaourt -S teamviewer --export $DIR
yaourt -S mintstick-git --noconfirm --export $DIR
yaourt -S mp3diags-unstable --noconfirm --export $DIR
yaourt -S skype --noconfirm --export $DIR
yaourt -S python2-pyparted --noconfirm --export $DIR
yaourt -S fingerprint-gui --noconfirm --export $DIR
yaourt -S yaourt --noconfirm --export $DIR
mv *.pkg.tar.xz /home/

