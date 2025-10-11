#!/bin/sh
# Update system packages (apt or pkcon)

if command -v pkcon >/dev/null; then
    pkcon refresh
    pkcon update
else
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt-get autoremove
fi
