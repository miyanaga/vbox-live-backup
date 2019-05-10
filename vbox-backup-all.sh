#!/bin/sh

BACKUP=${1%/}

alias vbox="VBoxManage"

vbox list vms \
  | perl -ne 's/^"|" {.+\n*$//g; push @vms, $_; END{ print join "\0", @vms }' \
  | xargs -0 -n 1 -I {} ./vbox-backup-vm.sh "{}" "$BACKUP"