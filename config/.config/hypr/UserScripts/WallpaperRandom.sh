#!/bin/bash
# Script for Random Wallpaper ( CTRL ALT W)

wallDIR="$HOME/Pictures/wallpapers"
scriptsDir="$HOME/.config/hypr/scripts"
wallpaper_effects="$HOME/.config/hypr/wallpaper_effects"

focused_monitor=$(hyprctl monitors | awk '/^Monitor/{name=$2} /focused: yes/{print name}')

PICS=($(find ${wallDIR} -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" -o -name "*.gif" \)))
RANDOMPICS=${PICS[ $RANDOM % ${#PICS[@]} ]}

cp "$RANDOMPICS" "$wallpaper_effects/.wallpaper_current"
cp "$RANDOMPICS" "$wallpaper_effects/.wallpaper_modified"
hyprctl hyprpaper wallpaper "$focused_monitor,$RANDOMPICS"
wallust run "$RANDOMPICS" -s &
"${scriptsDir}/Refresh.sh"

