#!/usr/local/bin/bash

# dynamically adjust titlebar & border for tling/floating windows
#   tiling -> titlebar: false, border_size: 1
#   floating -> titlebar: true, border_size: 1

swaymsg -m -t subscribe "['window']" --raw | {
  while read -r event; do
    if [[ $(jq -r '.change' <<< "${event}") == floating ]]; then
      con_id=$(jq -r '.container.id' <<< "${event}")
      con_type=$(jq -r '.container.type' <<< "${event}")
      if [[ ${con_type} == floating_con ]]; then
        swaymsg [con_id=${con_id}] border normal 1
      else
        swaymsg [con_id=${con_id}] border pixel 2
      fi
    fi
  done
}

