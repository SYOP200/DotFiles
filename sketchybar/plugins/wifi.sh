#!/bin/bash

# Run Apple Shortcut to get SSID
SSID=$(shortcuts run "Get Wi-Fi SSID")

# Trim whitespace
SSID=$(echo "$SSID" | xargs)

# Icons (you can swap these with Nerd Font icons if you prefer)
ICON_CONNECTED="󰤨"
ICON_DISCONNECTED="󰤭"

if [ -z "$SSID" ] || [ "$SSID" = "No Wi-Fi" ]; then
  sketchybar --set "$NAME" \
    icon="$ICON_DISCONNECTED" \
    label="No Internet"
else
  sketchybar --set "$NAME" \
    icon="$ICON_CONNECTED" \
    label="$SSID"
fi
