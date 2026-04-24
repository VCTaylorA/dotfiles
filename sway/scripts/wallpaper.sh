#!/bin/bash

# Wallpaper directory
WALLPAPER_DIR="$HOME/Pictures/Wallpaper copy"

# Interval between transitions (in seconds)
INTERVAL=300

# Get array of wallpapers
mapfile -t WALLPAPERS < <(find "$WALLPAPER_DIR" -maxdepth 1 \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) | sort)

if [ ${#WALLPAPERS[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

echo "Found ${#WALLPAPERS[@]} wallpapers. Rotating every ${INTERVAL}s"

# Initialize wallpaper index
INDEX=0

# Check which tool is available (prefer swww for smooth transitions)
if command -v swww &> /dev/null; then
    # Initialize swww daemon if not running
    swww init
    
    while true; do
        CURRENT_WALLPAPER="${WALLPAPERS[$INDEX]}"
        echo "Setting wallpaper: $CURRENT_WALLPAPER"
        
        # Use swww with transition effect (wipe transition)
        swww img "$CURRENT_WALLPAPER" --transition-type wipe --transition-duration 2
        
        INDEX=$(( (INDEX + 1) % ${#WALLPAPERS[@]} ))
        sleep "$INTERVAL"
    done
    
elif command -v swaybg &> /dev/null; then
    # Fallback to swaybg (no transitions)
    while true; do
        CURRENT_WALLPAPER="${WALLPAPERS[$INDEX]}"
        echo "Setting wallpaper: $CURRENT_WALLPAPER"
        
        pkill swaybg
        swaybg -i "$CURRENT_WALLPAPER" &
        
        INDEX=$(( (INDEX + 1) % ${#WALLPAPERS[@]} ))
        sleep "$INTERVAL"
    done
else
    echo "Neither swww nor swaybg found. Install one of them:"
    echo "  swww: for smooth transitions"
    echo "  swaybg: fallback option"
    exit 1
fi
