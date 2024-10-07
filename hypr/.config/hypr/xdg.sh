#!/bin/bash
sleep 1
killall -e xdg-desktop-portal-hyprland
killall -e xdg-desktop-portal-wlr
killall xdg-desktop-portal

echo "Starting xdg-desktop-portal-hyprland" >> xdg-desktop-portal-hyprland.log
/usr/local/libexec/xdg-desktop-portal-hyprland >> xdg-desktop-portal-hyprland.log 2>&1 &
sleep 2
/usr/local/libexec/xdg-desktop-portal &
