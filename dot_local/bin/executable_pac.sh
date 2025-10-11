#!/bin/sh
# Update Arch Linux packages with yay and clean cache

sudo pacman -Syyu
paccache -r
