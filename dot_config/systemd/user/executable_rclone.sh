#!/usr/bin/bash
set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <remote>"
  exit 1
fi

if command -v yad &>/dev/null; then
  sleep 1
  GDK_BACKEND=x11 yad --notification --image=/usr/share/icons/breeze-dark/actions/16/folder-sync-symbolic.svg &
  pid=${!}
  sleep 4
  kill ${pid}
else
  echo "yad is not installed."
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
  --vfs-cache-mode full \
  --cache-dir "$HOME/Archiv/rclone_cache/$1" \
  --log-level INFO
# --buffer-size 256M \
# --timeout 15s \
# --dir-cache-time 10m \
# --low-level-retries 3 \
# --retries 5 \
# --fuse-flag sync_read \
