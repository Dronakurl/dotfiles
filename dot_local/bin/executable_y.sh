#!/bin/sh
# yazi file manager wrapper that changes to the last visited directory

tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
TERM=xterm-kitty yazi "$@" --cwd-file="$tmp" 2>/dev/null

if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd "$cwd" || exit 1
    # For shells to pick up the directory change, we need to use a wrapper function
    # This script outputs the target directory for the shell function to use
    echo "$cwd"
fi
rm -f -- "$tmp"
