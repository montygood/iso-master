DIR="~/pkg"
mkdir -p $DIR
yaourt -S pamac-aur --noconfirm --needed --export $DIR
mv $DIR/pamac*.pkg.tar.xz $DIR/pkg/pamac.pkg.tar.xz

yaourt -S aic94xx-firmware --noconfirm --export $DIR
mv $DIR/aic94xx-firmware*.pkg.tar.xz $DIR/pkg/aic94xx-firmware.pkg.tar.xz

yaourt -S wd719x-firmware --noconfirm --export $DIR
mv $DIR/wd719x-firmware*.pkg.tar.xz $DIR/pkg/wd719x-firmware.pkg.tar.xz

yaourt -S mint-x-icons --noconfirm --export $DIR
mv $DIR/mint-x-icons*.pkg.tar.xz $DIR/pkg/mint-x-icons.pkg.tar.xz

yaourt -S wakeonlan --noconfirm --export $DIR
mv $DIR/wakeonlan*.pkg.tar.xz $DIR/pkg/wakeonlan.pkg.tar.xz

yaourt -S mp3gain --noconfirm
cp /usr/bin/mp3gain $DIR/pkg/

yaourt -S codecs64 --noconfirm --export $DIR
mv $DIR/codecs64*.pkg.tar.xz $DIR/pkg/codecs64.pkg.tar.xz

yaourt -S mediaelch --noconfirm --export $DIR
mv $DIR/mediaelch*.pkg.tar.xz $DIR/pkg/mediaelch.pkg.tar.xz

yaourt -S teamviewer --noconfirm --export $DIR
mv $DIR/teamviewer*.pkg.tar.xz $DIR/pkg/teamviewer.pkg.tar.xz

yaourt -S mintstick-git --noconfirm --export $DIR
mv $DIR/mintstick-git*.pkg.tar.xz $DIR/pkg/mintstick-git.pkg.tar.xz

yaourt -S mp3diags-unstable --noconfirm --export $DIR
mv $DIR/mp3diags-unstable*.pkg.tar.xz $DIR/pkg/mp3diags-unstable.pkg.tar.xz

yaourt -S skype --noconfirm --export $DIR
mv $DIR/skype*.pkg.tar.xz $DIR/pkg/skype.pkg.tar.xz

