#!/usr/bin/env bash

# Layouts to cycle through on click, in order
LAYOUTS=(
  com.apple.keylayout.Swedish-Pro
  com.apple.keylayout.US
)

if [ "$SENDER" = "mouse.clicked" ]; then
  CURRENT="$(macism)"
  NEXT="${LAYOUTS[0]}"
  for i in "${!LAYOUTS[@]}"; do
    if [ "${LAYOUTS[$i]}" = "$CURRENT" ]; then
      NEXT="${LAYOUTS[$(( (i + 1) % ${#LAYOUTS[@]} ))]}"
    fi
  done
  macism "$NEXT"
fi

# com.apple.keylayout.Swedish-Pro -> Swedish
LAYOUT="$(macism | sed -e 's/.*\.//' -e 's/-.*//')"

sketchybar --set "$NAME" label="$LAYOUT"
