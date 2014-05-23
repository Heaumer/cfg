#!/bin/sh

# make sure /usr/local is rw for `whoami`...

mkdir $HOME/bin; mkdir $HOME/src; mkdir $HOME/man

ip9p() {
	cd; hg clone http://code.swtch.com/plan9port plan9
	cd plan9; ./INSTALL
}

igo() {
	cd; hg clone -u release https://code.google.com/p/go
	cd go/src; ./all.bash
}

idwm() {
	cd $HOME/src; git clone http://git.suckless.org/dwm
	cp $HOME/cfg/dwm_config.h $HOME/src/dwm/config.h
	make; make install
}

idmenu() {
	cd $HOME/src; git clone http://git.suckless.org/dmenu
	cd dmenu; make; make install
}

iurxvt() {
	cvs -z3 -d :pserver:anonymous@cvs.schmorp.de/schmorpforge co rxvt-unicode
	cd rxvt-unicode
	# enalbe perl for extensions (plumber)
	./configure --enable-mousewheel --enable-perl --enable-transparency
	make; make install
}

iqemu() {
	cd $HOME/src; git clone git://git.qemu-project.org/qemu.git
	cd qemu
	# enable kvm and only 386 support
	./configure --enable-kvm --target-list=i386-softmmu;
	make; make install
}

idrawterm() {
	cd $HOME/src; hg clone http://code.swtch.com/drawterm
	cd drawterm
	CONF=unix make
	cp drawterm /usr/local/bin/
}

ip9p; igo; idwm; idmenu; iurxvt; iqemu; idrawterm;

# configuration files
cp .* $HOME

# awesome paste
curl  https://raw.github.com/acieroid/paste-py/master/paste.sh > bin/paste; chmod +x bin/paste

curl  https://raw.github.com/heaumer/snap/master/snap > bin/snap; chmod +x bin/snap

# plumber extensions for urxvt, $HOME/cfg/urxvt/plumb
mkdir urxvt; wget http://sqweek.net/urxvt/plumb -O urxvt/plumb

# remove compilation bits
clean() {
	for i in $HOME/src/*; do
		cd $i; make clean
	done
}
# clean

