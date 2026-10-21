#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/colors.sh"

CORES="$(sysctl -n hw.ncpu)"
USAGE="$(ps -A -o %cpu= | awk -v cores="$CORES" '{ s += $1 } END { printf "%d", s / cores }')"
LOAD="$(sysctl -n vm.loadavg | awk '{ print $2 }')"

sketchybar --set "$NAME" label="${USAGE}% (${LOAD})" label.color="$(state_color "$USAGE")"
