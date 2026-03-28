#!/bin/bash

#-----Defaults-----#
default=(
  padding_left=5
  padding_right=5
  icon.font="Hack Nerd Font:Bold:17.0"
  label.font="Hack Nerd Font:Bold:14.0"
  icon.color=0xffffffff
  label.color=0xffffffff
  background.color=0x99303234 \
  background.corner_radius=8 \
  background.height=25 \
  icon.padding_left=0
  icon.padding_right=0
  label.padding_left=4
  label.padding_right=4
)
sketchybar --default "${default[@]}"