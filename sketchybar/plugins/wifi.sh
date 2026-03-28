#!/usr/bin/env sh

#CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
#SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"
#CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"

#shortcuts run "Get Wi-Fi SSID"
#output=$(shortcuts run "Get Wi-Fi SSID")
#
#sketchybar --set $NAME label=$output icon=􀙇
#if $output = "-"
#  sketchybar --set $NAME label="No Internet"

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
