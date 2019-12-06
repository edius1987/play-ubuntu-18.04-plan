#!/usr/bin/env bash

set -e


################################################################################
### Head: icewm
##
icewm_config_install () {
	mkdir -p "$HOME/.icewm"
	echo "mkdir -p $HOME/.icewm"

	cp "./config/icewm/focus_mode" "$HOME/.icewm/focus_mode"
	echo "cp ./config/icewm/focus_mode $HOME/.icewm/focus_mode"

	cp "./config/icewm/keys" "$HOME/.icewm/keys"
	echo "cp ./config/icewm/keys $HOME/.icewm/keys"

	cp "./config/icewm/preferences" "$HOME/.icewm/preferences"
	echo "cp ./config/icewm/preferences $HOME/.icewm/preferences"

	cp "./config/icewm/prefoverride" "$HOME/.icewm/prefoverride"
	echo "cp ./config/icewm/prefoverride $HOME/.icewm/prefoverride"

	cp "./config/icewm/startup" "$HOME/.icewm/startup"
	echo "cp ./config/icewm/startup $HOME/.icewm/startup"

	cp "./config/icewm/theme" "$HOME/.icewm/theme"
	echo "cp ./config/icewm/theme $HOME/.icewm/theme"

	cp "./config/icewm/toolbar" "$HOME/.icewm/toolbar"
	echo "cp ./config/icewm/toolbar $HOME/.icewm/toolbar"

}
##
### Tail: icewm
################################################################################


################################################################################
### Head: volumeicon
##
volumeicon_config_install () {

	mkdir -p "$HOME/.config/volumeicon"
	echo "mkdir -p $HOME/.config/volumeicon"

	cp ./config/volumeicon/volumeicon "$HOME/.config/volumeicon/volumeicon"
	echo "cp ./config/volumeicon/volumeicon $HOME/.config/volumeicon/volumeicon"

}
##
### Tail: volumeicon
################################################################################


################################################################################
### Head: compton
##
compton_config_install () {

	## $ dpkg -L compton | grep conf
	## /usr/share/doc/compton/examples/compton.sample.conf

	## cp $(dpkg -L compton | grep conf) ~/.config/compton.conf

	echo "cp /usr/share/doc/compton/examples/compton.sample.conf $HOME/.config/compton.conf"
	cp "/usr/share/doc/compton/examples/compton.sample.conf" $HOME/.config/compton.conf

}
##
### Tail: compton
################################################################################


################################################################################
### Head: pcmanfm-qt
##
pcmanfm_qt_config_install () {

	mkdir -p "$HOME/.config/pcmanfm-qt/default"
	echo "mkdir -p $HOME/.config/pcmanfm-qt/default"

	cp ./config/pcmanfm-qt/default/settings.conf "$HOME/.config/pcmanfm-qt/default/settings.conf"
	echo "cp ./config/pcmanfm-qt/default/settings.conf $HOME/.config/pcmanfm-qt/default/settings.conf"

}
##
### Tail: pcmanfm-qt
################################################################################


################################################################################
### Head: rofi
##
rofi_config_install () {
	mkdir -p $HOME/.config/rofi
	echo "mkdir -p $HOME/.config/rofi"

	cp ./config/rofi/config $HOME/.config/rofi/config
	echo "cp ./config/rofi/config $HOME/.config/rofi/config"
}
##
### Tail: rofi
################################################################################


################################################################################
### Head: sakura
##
sakura_config_install () {
	mkdir -p $HOME/.config/sakura
	echo "mkdir -p $HOME/.config/sakura"

	cp ./config/sakura/sakura.conf $HOME/.config/sakura/sakura.conf
	echo "cp ./config/sakura/sakura.conf $HOME/.config/sakura/sakura.conf"
}
##
### Tail: sakura
################################################################################


################################################################################
### Head: fcitx
##
fcitx_config_install () {
	mkdir -p $HOME/.config/fcitx
	echo "mkdir -p $HOME/.config/fcitx"

	cp ./config/fcitx/profile $HOME/.config/fcitx/profile
	echo "cp ./config/fcitx/profile $HOME/.config/fcitx/profile"

	fcitx_config_install_im_config

}

fcitx_config_install_im_config () {
	echo
	im-config -n fcitx
	echo "im-config -n fcitx"
	echo "cat ~/.xinputrc"
	cat ~/.xinputrc
	echo
}
##
### Tail: fcitx
################################################################################


################################################################################
### Head: gtk3
##
gtk3_config_install () {
	mkdir -p $HOME/.config/gtk-3.0
	echo "mkdir -p $HOME/.config/gtk-3.0"

	cp ./config/gtk3/settings.ini $HOME/.config/gtk-3.0/settings.ini
	echo "cp ./config/gtk3/settings.ini $HOME/.config/gtk-3.0/settings.ini"
}
##
### Tail: gtk3
################################################################################


################################################################################
### Head: gtk2
##
gtk2_config_install () {

	cp ./config/gtk2/.gtkrc-2.0 $HOME/.gtkrc-2.0
	echo "cp ./config/gtk2/.gtkrc-2.0 $HOME/.gtkrc-2.0"

}
##
### Tail: gtk2
################################################################################


################################################################################
### Head: main
##
main_config_install () {

	icewm_config_install

	volumeicon_config_install

	compton_config_install

	pcmanfm_qt_config_install

	rofi_config_install

	sakura_config_install

	fcitx_config_install

	gtk3_config_install

	gtk2_config_install

}
## start
main_config_install

##
### Tail: main
################################################################################
