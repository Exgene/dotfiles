#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# for changing Hyprland Layouts (Master or Dwindle) on the fly

notif="$HOME/.config/swaync/images/bell.png"

# Read an option; Lua configs use "a.b.c", older hyprlang used "a:b:c"
get_opt() {
	local out
	out=$(hyprctl -j getoption "${1//:/.}" 2>/dev/null)
	jq -e . >/dev/null 2>&1 <<<"$out" || out=$(hyprctl -j getoption "${1//./:}" 2>/dev/null)
	printf '%s\n' "$out"
}

LAYOUT=$(get_opt general.layout | jq -r '.str')

case $LAYOUT in
"master")
	hyprctl eval '
		hl.config({ general = { layout = "dwindle" } })
		hl.unbind("SUPER + J")
		hl.unbind("SUPER + K")
		hl.bind("SUPER + J", hl.dsp.window.cycle_next())
		hl.bind("SUPER + K", hl.dsp.window.cycle_next({ next = false }))
		hl.bind("SUPER + O", hl.dsp.layout("togglesplit"))
	'
  notify-send -e -u low -i "$notif" "Dwindle Layout"
	;;
"dwindle")
	hyprctl eval '
		hl.config({ general = { layout = "master" } })
		hl.unbind("SUPER + J")
		hl.unbind("SUPER + K")
		hl.unbind("SUPER + O")
		hl.bind("SUPER + J", hl.dsp.layout("cyclenext"))
		hl.bind("SUPER + K", hl.dsp.layout("cycleprev"))
	'
  notify-send -e -u low -i "$notif" "Master Layout"
	;;
*) ;;

esac
