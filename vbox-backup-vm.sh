#!/bin/sh

VM=${1%\n}
BACKUPDIR=${2%/}

SERIAL=`date "+%Y%m%d%H%M%S"`
SNAPSHOT="$VM-backup-$SERIAL"
BACKUPFILE="$BACKUPDIR/$SNAPSHOT.ova"

alias vbox="VBoxManage"

RUNNING=`vbox showvminfo "$VM" --machinereadable | grep -c 'VMState="running"'`

if [ $RUNNING -ne 1 ]; then
  echo "Try to export VM $VM to $BACKUPFILE"
  vbox export "$VM" -o "$BACKUPFILE" \
    --ovf10 --manifest
  exit
fi

echo "Take snapshot of $VM as $SNAPSHOT"
vbox snapshot "$VM" take "$SNAPSHOT" --live && \
\
echo "Clone snapshot of $VM to temporary VM $SNAPSHOT on $CLONEDIR" && \
vbox clonevm "$VM" --snapshot "$SNAPSHOT" \
  --mode machine --options keepallmacs \
  --name "$SNAPSHOT" --basefolder "$CLONEDIR" --register && \
\
echo "Discard state of temporary VM $SNAPSHOT" && \
vbox discardstate "$SNAPSHOT" && \
\
echo "Export temporary VM $SNAPSHOT to $BACKUPFILE" && \
vbox export "$SNAPSHOT" -o "$BACKUPFILE" \
  --ovf10 --manifest && \

echo "Delete temporary VM $SNAPSHOT"
vbox unregistervm "$SNAPSHOT" --delete

echo "Delete snapshot $SNAPSHOT"
vbox snapshot "$VM" delete "$SNAPSHOT"

echo "Delete clone directory $CLONEDIR"
rm -rf "$CLONEDIR"