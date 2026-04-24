#!/bin/bash
#
# A rofi/wofi menu for volume control using wpctl.
#

# Check for dependencies
if ! command -v wpctl &> /dev/null || ! command -v wofi &> /dev/null; then
    echo "Please install wpctl (wireplumber) and wofi" >&2
    exit 1
fi

# Main function
main() {
    # Get menu entries
    mapfile -t entries < <(get_entries)

    # Display menu
    selection=$(printf '%s\n' "${entries[@]}" | wofi --dmenu --prompt "Volume" --style ~/.config/wofi/gruvbox-menu.css)

    # Process selection
    if [[ -n "$selection" ]]; then
        process_selection "$selection"
    fi
}

# Get menu entries
get_entries() {
    # Get volume status
    volume_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
    volume=$(echo "$volume_info" | awk '{print $2 * 100}')
    is_muted=$(echo "$volume_info" | grep -q "MUTED")

    if $is_muted; then
        echo "󰸈 Unmute (currently muted)"
    else
        echo "󰸅 Mute (currently at ${volume}%)"
    fi

    echo "󰁝 Set Volume to 25%"
    echo "󰁞 Set Volume to 50%"
    echo "󰁟 Set Volume to 75%"
    echo "󰁠 Set Volume to 100%"
}

# Process selection
process_selection() {
    selection="$1"
    case "$selection" in
        "󰸈 Unmute"*)
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
            ;;
        "󰸅 Mute"*)
            wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
            ;;
        "󰁝 Set Volume to 25%")
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 25%
            ;;
        "󰁞 Set Volume to 50%")
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
            ;;
        "󰁟 Set Volume to 75%")
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 75%
            ;;
        "󰁠 Set Volume to 100%")
            wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%
            ;;
    esac
}

# Run main function
main
