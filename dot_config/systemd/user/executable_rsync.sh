#!/usr/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <remote>"
  exit 1
fi
echo "Starting rclone bisync for remote $1"

MOUNTDIR="$HOME/rsync/$1"
mkdir -p "$MOUNTDIR"
mkdir -p "$HOME/tmp/rsync.$1"

rclone bisync "$MOUNTDIR" "$1": \
  --config "$HOME/.config/rclone/rclone.conf" \
  --temp-dir "$HOME/tmp/rsync.$1" \
  --log-level INFO \
  $2
