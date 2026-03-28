#!bin/bash

sketchybar -m --add item packages left \
              --set packages update_freq=1800 \
              --set packages script="~/.config/sketchybar/plugins/package_monitor.sh" \
              --set packages label="􀐚" \
              --set packages background.drawing=on \