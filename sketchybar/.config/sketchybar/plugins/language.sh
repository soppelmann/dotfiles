#!/usr/bin/env bash

# com.apple.keylayout.Swedish-Pro -> Swedish
LAYOUT="$(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleCurrentKeyboardLayoutInputSourceID \
  | sed -e 's/.*\.//' -e 's/-.*//')"

sketchybar --set "$NAME" label="$LAYOUT"
