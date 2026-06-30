#!/bin/bash
# Variables
scriptsDir=$HOME/.config/hypr/scripts
wallpaper=$HOME/.config/hypr/wallpaper_effects/.wallpaper_modified
waybar_style="$HOME/.config/waybar/style/[Dark] Latte-Wallust combined.css"
kvantum_theme="Catppuccin-Mocha"
color_scheme="prefer-dark"
gtk_theme="Andromeda-dark"
icon_theme="Flat-Remix-Blue-Dark"
cursor_theme="Bibata-Modern-Ice"

# Check if a marker file exists.
if [ ! -f ~/.config/hypr/.initial_startup_done ]; then
    sleep 1
    # Initialize wallust and wallpaper
	if [ -f "$wallpaper" ]; then
		wallust run -s "$wallpaper" > /dev/null
	fi
     
    # initiate GTK dark mode and apply icon and cursor theme
    gsettings set org.gnome.desktop.interface color-scheme $color_scheme > /dev/null 2>&1 &
    gsettings set org.gnome.desktop.interface gtk-theme $gtk_theme > /dev/null 2>&1 &
    gsettings set org.gnome.desktop.interface icon-theme $icon_theme > /dev/null 2>&1 &
    gsettings set org.gnome.desktop.interface cursor-theme $cursor_theme > /dev/null 2>&1 &
    gsettings set org.gnome.desktop.interface cursor-size 24 > /dev/null 2>&1 &
    sed -i 's/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=1/' "$HOME/.config/gtk-3.0/settings.ini"
    sed -i 's/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=1/' "$HOME/.config/gtk-4.0/settings.ini"
    
    # initiate kvantum theme
    kvantummanager --set "$kvantum_theme" > /dev/null 2>&1 &

    # initiate the kb_layout (for some reason) waybar cant launch it
    "$scriptsDir/SwitchKeyboardLayout.sh" > /dev/null 2>&1 &

    # Initial waybar style
	if [ -f "$waybar_style" ]; then
    	ln -sf "$waybar_style" "$HOME/.config/waybar/style.css"

		# Refreshing waybar, swaync, rofi etc. 
		"$scriptsDir/Refresh.sh" > /dev/null 2>&1 & 
	fi

    # Create a marker file to indicate that the script has been executed.
    touch ~/.config/hypr/.initial_startup_done

    exit
fi
