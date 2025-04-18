#!/usr/bin/bash
# shellcheck disable=SC2181

set -e

GDK_BACKEND=x11 yad --notification --image=/usr/share/icons/breeze-dark/actions/16/folder-sync.svg &
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

if [ "$1" == "ionosmirror" ]; then
  # add_options="--compare size,checksum"
  add_options="--size-only"
# elif [ "$1" == "dropboxmirror" ]; then
#   add_options="--size-only"
fi

rclone bisync "$SYNCDIR" "$1": \
  --config "$HOME/.config/rclone/rclone.conf" \
  --temp-dir "$HOME/tmp/rsync.$1" \
  --log-level INFO \
  $2 \
  $add_options

if [ $? -ne 0 ]; then
  notify-send "Rclone Error" "Rclone bisync for remote $1 failed!"
fi

kill ${pid}
