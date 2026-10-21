#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/colors.sh"

if [ "$SELECTED" = "true" ]; then
  sketchybar --set "$NAME" background.color=$WHITE
else
  sketchybar --set "$NAME" background.color=$TRANSPARENT
fi
