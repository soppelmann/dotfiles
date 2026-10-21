#!/usr/bin/env bash

source "$CONFIG_DIR/plugins/colors.sh"

BATT="$(pmset -g batt)"
PERCENTAGE="$(echo "$BATT" | grep -Eo '[0-9]+%' | tr -d '%')"
CHARGING="$(echo "$BATT" | grep 'AC Power')"

[ -z "$PERCENTAGE" ] && exit 0

update() {
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
}

# "100%; charged; 0:00 remaining" -> status and time left
fill_details() {
  local info status remaining source
  info="$(echo "$BATT" | grep -Eo '[0-9]+%;.*')"
  status="$(echo "$info" | cut -d';' -f2 | xargs)"
  remaining="$(echo "$info" | grep -Eo '[0-9]+:[0-9]+ remaining')"
  source="$(echo "$BATT" | grep -Eo "'.*'" | tr -d "'")"

  [ -z "$remaining" ] && remaining="estimating..."

  sketchybar --set battery.status label="$PERCENTAGE% $status ($source)" \
             --set battery.remaining label="$remaining"
}

case "$SENDER" in
  mouse.clicked)
    if [ "$BUTTON" = "right" ]; then
      open 'x-apple.systempreferences:com.apple.Battery-Settings.extension'
    else
      fill_details
      sketchybar --set "$NAME" popup.drawing=toggle
    fi
    ;;
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    ;;
  *)
    update
    ;;
esac
