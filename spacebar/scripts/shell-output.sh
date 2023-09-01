#!/bin/bash

output=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I)
airport=$(echo "$output" | grep 'AirPort' | awk -F': ' '{print $2}')

if [ "$airport" = "Off" ]; then
  echo "Offline"
else
  echo "$(echo "$output" | grep ' SSID'  | xargs | awk -F': ' 'echo $2' | sed 's/SSID: //' )" 
fi

result=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I \
    | grep "CtlRSSI\|agrCtlNoise" \
    | sed -e 's/^.*://g'  | { read -r a; read -r b; printf '%s\n' $((a-b)); })

printf ' '
# echo $result
if ((result > 40))
then
    echo "[++++]"
elif ((result > 25 && result <= 40))
then
    echo "[+++-]"
elif ((result > 15 && result <= 25))
then
    echo "[++--]"
elif ((result > 10 && result <= 15))
then
    echo "[+---]"
elif (( result > 0 &&result < 10  ))
then
    echo "[----]"
elif (( result == 0 ))
then
    echo "Off"
fi

echo " ⌨️ $(defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | command rg -e '"KeyboardLayout Name" = "*([^"]*)"*;' --replace '$1' --only-matching --color never | sed 's/ .*//')"
