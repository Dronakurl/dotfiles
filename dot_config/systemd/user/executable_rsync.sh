#!/usr/bin/bash
# shellcheck disable=SC2181

set -e

yad --notification --image=/usr/share/icons/breeze-dark/actions/16/folder-sync.svg &
pid=${!}

if [ -z "$1" ]; then
  echo "Usage: $0 <remote>"
  exit 1
fi
echo "Starting rclone bisync for remote $1"

SYNCDIR="$HOME/rsync/$1"
echo "Syncing $1 to $SYNCDIR"
mkdir -p "$SYNCDIR"
mkdir -p "$HOME/tmp/rsync.$1"

set +e

rclone bisync "$SYNCDIR" "$1": \
  --config "$HOME/.config/rclone/rclone.conf" \
  --temp-dir "$HOME/tmp/rsync.$1" \
  --log-level INFO \
  $2

if [ $? -ne 0 ]; then
  notify-send "Rclone Error" "Rclone bisync for remote $1 failed!"
fi

kill ${pid}
