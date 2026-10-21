#!/usr/bin/env bash

sketchybar --set "$NAME" label="$(date '+%e %b %Y' | sed 's/^ //')"
