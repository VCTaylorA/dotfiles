#!/bin/bash
choice=$(echo -e "Daylight (6500K)\nNeutral (4500K)\nWarm (3000K)\nVery Warm (2700K)" | wofi -d -p "Night Light")

case "$choice" in
    "Daylight"*) busctl --user call rs.wl_gammarelay / rs.wl_gammarelay.Program UpdateTemperature n 6500 ;;
    "Neutral"*) busctl --user call rs.wl_gammarelay / rs.wl_gammarelay.Program UpdateTemperature n 4500 ;;
    "Warm"*) busctl --user call rs.wl_gammarelay / rs.wl_gammarelay.Program UpdateTemperature n 3000 ;;
    "Very Warm"*) busctl --user call rs.wl_gammarelay / rs.wl_gammarelay.Program UpdateTemperature n 2700 ;;
esac
