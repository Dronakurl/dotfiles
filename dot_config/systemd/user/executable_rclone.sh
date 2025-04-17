#!/usr/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <remote>"
  exit 1
fi

if [ -d "/mnt/rclone/$1" ] && mountpoint -q "$HOME/rclone/$1"; then
  fusermount -u "$HOME/rclone/$1"
fi

rm -f "$HOME/rclone/$1"
mkdir -p "/mnt/rclone/$1"
ln -s "/mnt/rclone/$1" "$HOME/rclone/$1"
mkdir -p "$HOME/tmp/rclone.$1"
mkdir -p "$HOME/Archiv/rclone_cache/$1"

rclone mount "$1": "/mnt/rclone/$1" \
  --config "$HOME/.config/rclone/rclone.conf" \
  --temp-dir "$HOME/tmp/rclone.$1" \
  --dir-cache-time 10m \
  --low-level-retries 3 \
  --retries 5 \
  --timeout 15s \
  --vfs-cache-mode full \
  --buffer-size 256M \
  --cache-dir "$HOME/Archiv/rclone_cache/$1" \
  --log-level INFO \
  --use-mmap
# --fuse-flag sync_read \
