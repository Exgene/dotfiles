#!/bin/bash
# /* ---- 💫 https://github.com/JaKooLit 💫 ---- */  ##
# Game Mode. Turning off all animations

notif="$HOME/.config/swaync/images/bell.png"
SCRIPTSDIR="$HOME/.config/hypr/scripts"


# Read an option; Lua configs use "a.b.c", older hyprlang used "a:b:c"
get_opt() {
	local out
	out=$(hyprctl -j getoption "${1//:/.}" 2>/dev/null)
	jq -e . >/dev/null 2>&1 <<<"$out" || out=$(hyprctl -j getoption "${1//./:}" 2>/dev/null)
	printf '%s\n' "$out"
}

HYPRGAMEMODE=$(get_opt animations.enabled | jq -r 'if has("bool") then (if .bool then 1 else 0 end) else .int end')
if [ "$HYPRGAMEMODE" = 1 ] ; then
    hyprctl eval '
        hl.config({
            animations = { enabled = false },
            decoration = { shadow = { enabled = false }, blur = { passes = 0 }, rounding = 0 },
            general = { gaps_in = 0, gaps_out = 0, border_size = 1 },
        })
        hl.window_rule({ match = { class = ".*" }, opacity = "1 override 1 override 1 override" })
    '
    swww kill 
    notify-send -e -u low -i "$notif" "gamemode enabled. All animations off"
    exit
else
	swww-daemon --format xrgb && swww img "$HOME/.config/rofi/.current_wallpaper" &
	sleep 0.1
	${SCRIPTSDIR}/WallustSwww.sh
	sleep 0.5
	${SCRIPTSDIR}/Refresh.sh	 
    notify-send -e -u normal -i "$notif" "gamemode disabled. All animations normal"
    exit
fi
hyprctl reload
