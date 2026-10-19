#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Script for changing blurs on the fly

notif="$HOME/.config/swaync/images/bell.png"

# Read an option; Lua configs use "a.b.c", older hyprlang used "a:b:c"
get_opt() {
	local out
	out=$(hyprctl -j getoption "${1//:/.}" 2>/dev/null)
	jq -e . >/dev/null 2>&1 <<<"$out" || out=$(hyprctl -j getoption "${1//./:}" 2>/dev/null)
	printf '%s\n' "$out"
}

STATE=$(get_opt decoration.blur.passes | jq ".int")

if [ "${STATE}" == "2" ]; then
	hyprctl eval 'hl.config({ decoration = { blur = { size = 2, passes = 1 } } })'
 	notify-send -e -u low -i "$notif" "Less blur"
else
	hyprctl eval 'hl.config({ decoration = { blur = { size = 5, passes = 2 } } })'
  	notify-send -e -u low -i "$notif" "Normal blur"
fi
