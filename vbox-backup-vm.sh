#!/bin/sh

VM=${1%\n}
BACKUPDIR=${2%/}

SERIAL=`date "+%Y%m%d%H%M%S"`
SNAPSHOT="$VM-backup-$SERIAL"
CLONEDIR="$BACKUPDIR/$SERIAL"
BACKUPFILE="$BACKUPDIR/$SNAPSHOT.ova"

alias vbox="VBoxManage"

echo "Take snapshot of $VM as $SNAPSHOT"
vbox snapshot "$VM" take "$SNAPSHOT" --live

echo "Clone snapshot of $VM to temporary vm $SNAPSHOT on $CLONEDIR"
vbox clonevm "$VM" --snapshot "$SNAPSHOT" \
  --mode machine --options keepallmacs \
  --name "$SNAPSHOT" --basefolder "$CLONEDIR" --register

echo "Discard state of temporary vm $SNAPSHOT"
vbox discardstate "$SNAPSHOT"

echo "Export temporary vm $SNAPSHOT to $BACKUPFILE"
vbox export "$SNAPSHOT" -o "$BACKUPFILE" \
  --ovf10 --manifest

echo "Delete temporary vm $SNAPSHOT"
vbox unregistervm "$SNAPSHOT" --delete

echo "Delete snapshot $SNAPSHOT"
vbox snapshot "$VM" delete "$SNAPSHOT"

echo "Delete clone directory $CLONEDIR"
rm -rf "$CLONEDIR"