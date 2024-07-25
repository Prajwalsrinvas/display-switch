#!/bin/bash

# Log file path
LOG_FILE="/tmp/display_switch.log"

# Flag to enable/disable logging
LOGGING_ENABLED=false

# Function to log messages
log() {
    if [ "$LOGGING_ENABLED" = true ]; then
        echo "$(date): $1" >> "$LOG_FILE"
    fi
}

# Function to switch to laptop display only
switch_to_laptop() {
    log "Switching to laptop display only"
    xrandr --output eDP-1 --auto --output HDMI-1 --off
    log "Switch to laptop display completed"
}

# Function to switch to extended display
switch_to_extended() {
    log "Switching to extended display"
    xrandr --output eDP-1 --auto --output HDMI-1 --auto --right-of eDP-1
    log "Switch to extended display completed"
}

# Function to check if system is on battery
on_battery() {
    for battery in /sys/class/power_supply/BAT*; do
        if [ -e "$battery/status" ]; then
            status=$(cat "$battery/status")
            if [ "$status" = "Discharging" ]; then
                log "System is on battery"
                return 0  # True, on battery
            fi
        fi
    done
    log "System is on AC power"
    return 1  # False, not on battery
}

# Function to monitor power status and switch displays
monitor_power() {
    log "Starting power monitoring"
    local last_state=""
    while true; do
        if on_battery; then
            current_state="battery"
        else
            current_state="ac"
        fi
        
        if [ "$current_state" != "$last_state" ]; then
            log "Power state changed from $last_state to $current_state"
            if [ "$current_state" = "battery" ]; then
                switch_to_laptop
            else
                switch_to_extended
            fi
            last_state="$current_state"
        fi
        sleep 5
    done
}

# Main script
case "$1" in
    laptop)
        switch_to_laptop
        ;;
    extended)
        switch_to_extended
        ;;
    monitor)
        if [ "$2" = "--log" ]; then
            LOGGING_ENABLED=true
        fi
        monitor_power
        ;;
    *)
        echo "Usage: $0 {laptop|extended|monitor} [--log]"
        exit 1
esac
