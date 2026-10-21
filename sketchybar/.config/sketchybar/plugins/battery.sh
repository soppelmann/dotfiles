#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/colors.sh"

BATT="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT" | grep -Eo '[0-9]+%' | tr -d '%')"
CHARGING="$(echo "$BATT" | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

case "$PERCENTAGE" in
  9[0-9]|100) ICON="􀛨" ;;
  [6-8][0-9]) ICON="􀺸" ;;
  [3-5][0-9]) ICON="􀺶" ;;
  [1-2][0-9]) ICON="􀛩" ;;
  *) ICON="􀛪" ;;
esac

COLOR=$WHITE
if [ -n "$CHARGING" ]; then
  ICON="􀢋"
elif [ "$PERCENTAGE" -le 15 ]; then
  COLOR=$RED
elif [ "$PERCENTAGE" -le 30 ]; then
  COLOR=$ORANGE
fi

sketchybar --set "$NAME" icon="$ICON" icon.color=$COLOR \
                         label="${PERCENTAGE}%" label.color=$COLOR
