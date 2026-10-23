#!/usr/bin/env bash

# macOS settings that live in preferences rather than config files.
# Run once on a new machine: ./macos-defaults.sh

# -----------------------------------------------------------------------------
# Menu bar: auto-hide so sketchybar shows, real menu bar pops out on hover
# -----------------------------------------------------------------------------

defaults write NSGlobalDomain _HIHideMenuBar -bool true

# -----------------------------------------------------------------------------
# Rectangle: double-click title bar to maximize, leaving room for sketchybar
# -----------------------------------------------------------------------------

# Let Rectangle handle title bar double-clicks instead of macOS zoom
defaults write NSGlobalDomain AppleActionOnDoubleClick -string None

# Maximize on double-click (action id 2 + 1)
defaults write com.knollsoft.Rectangle doubleClickTitleBar -int 3

# Keep maximized windows below sketchybar (32pt), except on the notch
# display where macOS already reserves the menu bar area
defaults write com.knollsoft.Rectangle screenEdgeGapTop -int 32
defaults write com.knollsoft.Rectangle screenEdgeGapTopNotch -int 0

osascript -e 'quit app "Rectangle"' && sleep 1 && open -a Rectangle
