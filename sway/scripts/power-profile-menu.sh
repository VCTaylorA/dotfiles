#!/bin/bash

current=$(powerprofilesctl get)

choice=$(printf "󰾅 power-saver\n󰌪 balanced\n󰓅 performance" | \
    wofi --dmenu \
         --prompt "Power profile ($current)" \
         --width 250 \
         --height 180 \
         --style ~/.config/wofi/power.css)

case "$choice" in
  "󰾅 power-saver")
    powerprofilesctl set power-saver
    ;;
  "󰌪 balanced")
    powerprofilesctl set balanced
    ;;
  "󰓅 performance")
    powerprofilesctl set performance
    ;;
esac
