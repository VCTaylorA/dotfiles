#!/bin/bash
#
# A rofi/wofi menu for bluetoothctl.
#

# Check for dependencies
if ! command -v bluetoothctl &> /dev/null || ! command -v wofi &> /dev/null; then
    echo "Please install bluetoothctl and wofi" >&2
    exit 1
fi

# Main function
main() {
    # Get menu entries
    mapfile -t entries < <(get_entries)

    # Display menu
    selection=$(printf '%s\n' "${entries[@]}" | wofi --dmenu --prompt "Bluetooth" --style ~/.config/wofi/gruvbox-menu.css)

    # Process selection
    if [[ -n "$selection" ]]; then
        process_selection "$selection"
    fi
}

# Get menu entries
get_entries() {
    # Get bluetooth status
    if is_powered_on; then
        echo "󰂯 Power off"
    else
        echo "󰂲 Power on"
    fi

    # Return if bluetooth is not powered on
    if ! is_powered_on; then
        return
    fi

    # Get discover status
    if is_discovering; then
        echo "󰂰 Discover off"
    else
        echo "󰂰 Discover on"
    fi

    # Get pairable status
    if is_pairable; then
        echo "󰂯 Pairable off"
    else
        echo "󰂲 Pairable on"
    fi

    # Get devices
    mapfile -t devices < <(get_devices)
    if [[ "${#devices[@]}" -gt 0 ]]; then
        printf '%s\n' "${devices[@]}"
    fi
}

# Process selection
process_selection() {
    selection="$1"
    case "$selection" in
        "󰂯 Power off")
            bluetoothctl power off
            ;;
        "󰂲 Power on")
            bluetoothctl power on
            ;;
        "󰂰 Discover off")
            bluetoothctl scan off
            ;;
        "󰂰 Discover on")
            bluetoothctl scan on
            ;;
        "󰂯 Pairable off")
            bluetoothctl pairable off
            ;;
        "󰂲 Pairable on")
            bluetoothctl pairable on
            ;;
        *)
            # Get device info
            device_mac=$(echo "$selection" | awk '{print $2}')
            is_connected=$(echo "$selection" | grep "󰂱")

            # Process device selection
            if [[ -n "$is_connected" ]]; then
                bluetoothctl disconnect "$device_mac"
            else
                if ! bluetoothctl info "$device_mac" | grep -q "Paired: yes"; then
                    bluetoothctl pair "$device_mac"
                fi
                bluetoothctl connect "$device_mac"
            fi
            ;;
    esac
}

# Get bluetooth status
is_powered_on() {
    bluetoothctl show | grep -q "Powered: yes"
}

is_discovering() {
    bluetoothctl show | grep -q "Discovering: yes"
}

is_pairable() {
    bluetoothctl show | grep -q "Pairable: yes"
}

# Get devices
get_devices() {
    bluetoothctl devices | while read -r line; do
        device_mac=$(echo "$line" | awk '{print $2}')
        device_name=$(echo "$line" | cut -d ' ' -f 3-)
        
        if bluetoothctl info "$device_mac" | grep -q "Connected: yes"; then
            echo "󰂱 $device_mac $device_name"
        else
            echo "󰂯 $device_mac $device_name"
        fi
    done
}

# Run main function
main
