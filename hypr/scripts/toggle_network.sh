#!/bin/bash
# File: ~/.config/waybar/toggle_network.sh

# Toggle visibility of the network module
current_class=$(jq '.["network#speed"]["class"]' ~/.config/waybar/state.json)

if [[ $current_class == "\"hidden\"" ]]; then
    jq '.["network#speed"]["class"] = ""' ~/.config/waybar/state.json > ~/.config/waybar/temp.json && mv ~/.config/waybar/temp.json ~/.config/waybar/state.json
else
    jq '.["network#speed"]["class"] = "hidden"' ~/.config/waybar/state.json > ~/.config/waybar/temp.json && mv ~/.config/waybar/temp.json ~/.config/waybar/state.json
fi

# Reload waybar to apply the change
pkill -SIGRTMIN+1 waybar

