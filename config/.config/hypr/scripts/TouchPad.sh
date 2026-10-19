#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# For disabling touchpad.
# Keep TOUCHPAD_DEVICE in sync with Touchpad_Device in ~/.config/hypr/UserConfigs/Laptops.lua
# use hyprctl devices to get your system touchpad device name
# source https://github.com/hyprwm/Hyprland/discussions/4283?sort=new#discussioncomment-8648109

notif="$HOME/.config/swaync/images/bell.png"
TOUCHPAD_DEVICE="asue1209:00-04f3:319f-touchpad"

export STATUS_FILE="$XDG_RUNTIME_DIR/touchpad.status"

enable_touchpad() {
    printf "true" >"$STATUS_FILE"
    notify-send -u low -i $notif  "Enabling touchpad"
    hyprctl -r eval "hl.device({ name = \"$TOUCHPAD_DEVICE\", enabled = true })"
}

disable_touchpad() {
    printf "false" >"$STATUS_FILE"
    notify-send -u low -i $notif "Disabling touchpad"
    hyprctl -r eval "hl.device({ name = \"$TOUCHPAD_DEVICE\", enabled = false })"
}

if ! [ -f "$STATUS_FILE" ]; then
  enable_touchpad
else
  if [ $(cat "$STATUS_FILE") = "true" ]; then
    disable_touchpad
  elif [ $(cat "$STATUS_FILE") = "false" ]; then
    enable_touchpad
  fi
fi
