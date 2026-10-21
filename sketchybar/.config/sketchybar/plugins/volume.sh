#!/usr/bin/env bash

update() {
  local volume muted
  volume="$(osascript -e 'output volume of (get volume settings)')"
  muted="$(osascript -e 'output muted of (get volume settings)')"
  [ "$SENDER" = "volume_change" ] && volume="$INFO"

  case "$volume" in
    [6-9][0-9]|100) ICON="􀊩" ;;
    [3-5][0-9]) ICON="􀊧" ;;
    [1-9]|[1-2][0-9]) ICON="􀊥" ;;
    *) ICON="􀊣" ;;
  esac
  [ "$muted" = "true" ] && ICON="􀊣"

  sketchybar --set "$NAME" icon="$ICON" label="${volume}%"
}

# Rebuild the popup with one row per output device, current one marked
fill_devices() {
  local current i=0
  current="$(SwitchAudioSource -c -t output)"

  sketchybar --remove '/volume\.device\..*/' 2>/dev/null

  while IFS= read -r device; do
    local mark="  "
    [ "$device" = "$current" ] && mark="> "
    sketchybar --add item volume.device.$i popup.volume \
               --set volume.device.$i icon.drawing=off \
                                      padding_left=10 \
                                      padding_right=10 \
                                      label="$mark$device" \
                                      click_script="SwitchAudioSource -t output -s $(printf '%q' "$device"); sketchybar --set volume popup.drawing=off"
    i=$((i + 1))
  done < <(SwitchAudioSource -a -t output)
}

case "$SENDER" in
  mouse.clicked)
    if [ "$BUTTON" = "right" ]; then
      osascript -e 'set volume output muted not (output muted of (get volume settings))'
      update
    else
      fill_devices
      sketchybar --set "$NAME" popup.drawing=toggle
    fi
    ;;
  mouse.scrolled)
    osascript -e "set volume output volume (output volume of (get volume settings) + $SCROLL_DELTA * 2)"
    ;;
  mouse.exited.global)
    sketchybar --set "$NAME" popup.drawing=off
    ;;
  *)
    update
    ;;
esac
