#!/bin/bash
#
# A rofi/wofi menu for NetworkManager.
#

# Check for dependencies
if ! command -v nmcli &> /dev/null || ! command -v wofi &> /dev/null; then
    echo "Please install nmcli and wofi" >&2
    exit 1
fi

# Main function
main() {
    # Get menu entries
    mapfile -t entries < <(get_entries)

    # Display menu
    selection=$(printf '%s\n' "${entries[@]}" | wofi --dmenu --prompt "WiFi" --style ~/.config/wofi/gruvbox-menu.css)

    # Process selection
    if [[ -n "$selection" ]]; then
        process_selection "$selection"
    fi
}

# Get menu entries
get_entries() {
    # Get WiFi status
    if is_wifi_on; then
        echo "󰤨 Turn WiFi Off"
    else
        echo "󰤯 Turn WiFi On"
    fi

    # Return if WiFi is not on
    if ! is_wifi_on; then
        return
    fi

    # Get networks
    nmcli device wifi rescan >/dev/null 2>&1
    mapfile -t networks < <(get_networks)
    if [[ "${#networks[@]}" -gt 0 ]]; then
        printf '%s\n' "${networks[@]}"
    fi
}

# Process selection
process_selection() {
    selection="$1"
    case "$selection" in
        "󰤨 Turn WiFi Off")
            nmcli radio wifi off
            ;;
        "󰤯 Turn WiFi On")
            nmcli radio wifi on
            ;;
        *)
            # Get network info
            bssid=$(echo "$selection" | awk '{print $2}')
            ssid=$(echo "$selection" | awk '{print $3}')
            is_connected=$(echo "$selection" | grep "✓")

            # Process network selection
            if [[ -n "$is_connected" ]]; then
                nmcli connection down "$ssid"
            else
                if nmcli -t -f GENERAL.STATE,SSID,BSSID dev wifi con "$bssid" | grep -q "successfully activated"; then
                    : # Already connected
                else
                    # Prompt for password if needed
                    if echo "$selection" | grep -q "WPA"; then
                        password=$(wofi --dmenu --prompt "Password for $ssid" --style ~/.config/wofi/gruvbox-menu.css)
                        nmcli device wifi connect "$bssid" password "$password"
                    else
                        nmcli device wifi connect "$bssid"
                    fi
                fi
            fi
            ;;
    esac
}

# Get WiFi status
is_wifi_on() {
    nmcli radio wifi | grep -q "enabled"
}

# Get networks
get_networks() {
    nmcli -f IN-USE,BSSID,SSID,SECURITY dev wifi list | tail -n +2 | while read -r line; do
        in_use=$(echo "$line" | awk '{print $1}')
        bssid=$(echo "$line" | awk '{print $2}')
        ssid=$(echo "$line" | awk '{print $3}')
        security=$(echo "$line" | awk '{print $4}')
        
        if [[ "$in_use" == "*" ]]; then
            echo "✓ $bssid $ssid ($security)"
        else
            echo "  $bssid $ssid ($security)"
        fi
    done
}

# Run main function
main
