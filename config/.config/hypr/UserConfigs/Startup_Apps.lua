-- hl.exec_cmd runs through `sh -c` asynchronously, so no trailing `&` is needed
local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local UserScripts = home .. "/.config/hypr/UserScripts"

local wallDIR = home .. "/Pictures/wallpapers"

hl.on("hyprland.start", function()
    -- wallpaper stuff / More wallpaper options below
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("sleep 1; hyprctl hyprpaper wallpaper \"eDP-1,$HOME/.config/hypr/wallpaper_effects/.wallpaper_modified,contain\"")
    -- hl.exec_cmd(UserScripts .. "/WallpaperAutoChange.sh " .. wallDIR)

    -- Startup
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

    -- Polkit (Polkit Gnome / KDE)
    hl.exec_cmd(scriptsDir .. "/Polkit.sh")

    -- startup apps
    hl.exec_cmd("waybar")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("swaync")
    hl.exec_cmd("ags")
    -- hl.exec_cmd("blueman-applet")
    -- hl.exec_cmd("rog-control-center")

    -- clipboard manager
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")

    -- Starting hypridle to start hyprlock
    hl.exec_cmd("hypridle")

    -- User apps
    hl.exec_cmd("cd " .. home .. "/Apps && ./helium.AppImage", { workspace = "2" })
    hl.exec_cmd("ghostty", { workspace = "1" })
    hl.exec_cmd("youtube-music", { workspace = "10" })
end)
