#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/colors.sh"

FREE="$(memory_pressure | awk '/free percentage/ { gsub("%", "", $5); print $5 }')"
USED=$((100 - FREE))

sketchybar --set "$NAME" label="${USED}%" label.color="$(state_color "$USED")"
