#!/bin/sh
cat <<EOF >/dev/null
Title: current.sh (following slackware current)
Tags: code,shell,slack
Date: 20131129
Fmt: sed s,<,\&lt;,g;s,>,\&gt;,g;1s/^/<pre><code>/;$s,$,</code></pre>,
EOF

#!/bin/sh
PATH=/bin:/usr/bin

# package names assumed to match
# package-name-<version>.<arch>.txz
# ^[^0-9]*-[0-9].*\.txz

# sources discarded

version=`awk '{ print $2 }' /etc/slackware-version`
version=current
arch= # default is x86
#arch=64
mirror="http://mirrors.slackware.com/slackware$arch/slackware-$version/"
wdir=$HOME/update/
pkgdb="/var/log/packages/"
updatedb="$wdir/newpkgs"

# $1 greeting message
tellupdates() {
	awk ' /^\+-*\+$/ { exit }' ChangeLog.txt
	echo $1
	for i in `cat $updatedb`; do
		echo $i | sed "s,^,\tupgradepkg $wdir,g"
		echo $i | sed "s,^,\trm $wdir,g"
	done
	echo "	rm $updatedb"
}

mkdir $wdir 2>/dev/null
cd $wdir/ || (echo $wdir invalid; exit)

if [ -f "$updatedb" ]; then
	tellupdates "please, run first as root:"
	exit
fi

echo -n 'Downloading checksums & changelog... '
wget --quiet "$mirror/CHECKSUMS.md5" -O $$.md5
wget --quiet "$mirror/ChangeLog.txt"
echo 'Done.'

awk '
BEGIN {
	started=0
}

started && ($2 ~ /^\.\/extra\// || $2 ~ /^\.\/slackware\//)

/^MD5 message digest/ {
	started=1
}
' $$.md5 > clean.md5;

for p in `diff -u CHECKSUMS.md5 clean.md5 | awk '/^+.*\.txz$/ { print $2 }'`; do
	pn=`basename $p | sed 's/^\([^0-9]*\)-[0-9].*/\1/g'`
	ls $pkgdb/$pn-[0-9]* &>/dev/null && basename $p >> $updatedb
	wget -c $mirror/$p &>/dev/null
	# XXX Check MD5
done

if [ -f "$updatedb" ]; then
	tellupdates "to update, run as root:"
else
	echo up to date.
fi

# save new clean checksums file when done
mv clean.md5 CHECKSUMS.md5
rm ChangeLog.txt

rm $$.md5 2>/dev/null
