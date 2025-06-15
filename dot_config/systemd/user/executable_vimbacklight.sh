#!/bin/bash
red="242 23 0"
orange="242 128 0"
green="23 242 0"
# blue="0 23 242"

# Light bar
echo 4 | tee /sys/class/leds/rgb:lightbar/brightness
# Caps Lock
echo "$red" | tee /sys/class/leds/rgb:kbd_backlight_42/multi_intensity
# WASD
echo "$orange" | tee /sys/class/leds/rgb:kbd_backlight_66/multi_intensity
echo "$orange" | tee /sys/class/leds/rgb:kbd_backlight_44/multi_intensity
echo "$orange" | tee /sys/class/leds/rgb:kbd_backlight_45/multi_intensity
echo "$orange" | tee /sys/class/leds/rgb:kbd_backlight_46/multi_intensity
# HJKL
echo "$green" | tee /sys/class/leds/rgb:kbd_backlight_49/multi_intensity
echo "$red" | tee /sys/class/leds/rgb:kbd_backlight_50/multi_intensity
echo "$red" | tee /sys/class/leds/rgb:kbd_backlight_51/multi_intensity
echo "$green" | tee /sys/class/leds/rgb:kbd_backlight_52/multi_intensity
# delete
echo "$red" | tee /sys/class/leds/rgb:kbd_backlight_120/multi_intensity
# dim screen
echo "$orange" | tee /sys/class/leds/rgb:kbd_backlight_106/multi_intensity
echo "$orange" | tee /sys/class/leds/rgb:kbd_backlight_107/multi_intensity
# sound off
echo "$red" | tee /sys/class/leds/rgb:kbd_backlight_108/multi_intensity
echo "$red" | tee /sys/class/leds/rgb:kbd_backlight_111/multi_intensity
echo "$red" | tee /sys/class/leds/rgb:kbd_backlight_112/multi_intensity

echo 6 | tee /sys/class/leds/rgb:kbd_backlight_1/brightness
