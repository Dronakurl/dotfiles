#!/usr/bin/bash
# shellcheck disable=SC2181

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <remote>"
  exit 1
fi

if command -v yad &>/dev/null; then
  GDK_BACKEND=x11 yad --notification --image=/usr/share/icons/breeze-dark/actions/16/download-symbolic.svg --command="systemctl --user stop dump@$1.service" &
  pid=${!}
else
  echo "yad is not installed."
fi

echo "Starting rclone sync for remote $1"

SYNCDIR="$HOME/rsync/dump/$1"
echo "Syncing $1 to $SYNCDIR"
mkdir -p "$SYNCDIR"
mkdir -p "$HOME/tmp/rdump.$1"

set +e

rclone sync "$1": "$SYNCDIR" \
  --config "$HOME/.config/rclone/rclone.conf" \
  --temp-dir "$HOME/tmp/rsync.$1" \
  --log-level INFO \
  $2

if [ $? -ne 0 ]; then
  notify-send "Rclone Error" "Rclone sync for remote $1 failed!"
fi

if command -v yad &>/dev/null; then
  kill ${pid}
fi
