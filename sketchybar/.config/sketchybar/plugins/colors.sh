#!/usr/bin/env bash

WHITE=0xffffffff
ORANGE=0xffffa500
RED=0xffff0000
TRANSPARENT=0x00000000

# Pick a label color from a percentage: warning >= 70, critical >= 90
state_color() {
  if [ "$1" -ge 90 ]; then
    echo $RED
  elif [ "$1" -ge 70 ]; then
    echo $ORANGE
  else
    echo $WHITE
  fi
}
