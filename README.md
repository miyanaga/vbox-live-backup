# English

Simple shell script to backup virtual machines on VirtualBox without shutdown.

Backup files in your backup folder with timestamp.

Tested on macOs/VirtualBox 6.0.6.

## Backup a VM

    $ ./vbox-backup-vm.sh "VM name" "Backup Folder Path"

## Backup all VMs

    $ ./vbox-backup-all.sh "Backup Folder Path"

# 日本語

VirtualBoxのVMをすべて無停止でバックアップする簡易シェルスクリプトです。

バックアップは指定ディレクトリに日付付きファイル名でOVF形式で出力されます。

macOS/VirtualBox 6.0.6で動作確認しました。

# VMひとつのバックアップ

    $ ./vbox-backup-vm.sh "VMの名称" "バックアップ先フォルダ"

# VMすべてのバックアップ

    $ ./vbox-backup-all.sh "バックアップ先フォルダ"