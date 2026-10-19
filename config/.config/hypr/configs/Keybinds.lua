local mainMod = "SUPER"
local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local UserScripts = home .. "/.config/hypr/UserScripts"

local function exec(cmd) return hl.dsp.exec_cmd(cmd) end

hl.bind("CTRL + ALT + Delete", hl.dsp.exit())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + Q", exec(scriptsDir .. "/KillActiveProcess.sh"))
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
-- Toggle floating for every window on the current workspace
hl.bind(mainMod .. " + ALT + F", function()
    for _, w in ipairs(hl.get_workspace_windows(hl.get_active_workspace())) do
        hl.dispatch(hl.dsp.window.float({ action = "toggle", window = w }))
    end
end)
hl.bind("CTRL + ALT + L", exec(scriptsDir .. "/LockScreen.sh"))
hl.bind("CTRL + ALT + P", exec(scriptsDir .. "/Wlogout.sh"))

hl.bind(mainMod .. " + HOME", exec(scriptsDir .. "/KeyHints.sh")) -- Small help file
hl.bind(mainMod .. " + ALT + R", exec(scriptsDir .. "/Refresh.sh")) -- Refresh waybar, swaync, rofi
hl.bind(mainMod .. " + ALT + E", exec(scriptsDir .. "/RofiEmoji.sh")) -- emoji
hl.bind(mainMod .. " + S", exec(scriptsDir .. "/RofiSearch.sh")) -- Google search from Rofi
hl.bind(mainMod .. " + SHIFT + B", exec(scriptsDir .. "/ChangeBlur.sh")) -- Toggle blur settings
hl.bind(mainMod .. " + SHIFT + G", exec(scriptsDir .. "/GameMode.sh")) -- animations ON/OFF
hl.bind(mainMod .. " + ALT + L", exec(scriptsDir .. "/ChangeLayout.sh")) -- Toggle Master or Dwindle Layout
hl.bind(mainMod .. " + ALT + V", exec(scriptsDir .. "/ClipManager.sh")) -- Clipboard Manager
hl.bind(mainMod .. " + SHIFT + N", exec("swaync-client -t -sw")) -- swayNC panel

hl.bind(mainMod .. " + E", exec(UserScripts .. "/QuickEdit.sh")) -- Quick Edit Hyprland Settings
hl.bind(mainMod .. " + SHIFT + M", exec(UserScripts .. "/RofiBeats.sh")) -- online music
hl.bind(mainMod .. " + W", exec(UserScripts .. "/WallpaperSelect.sh")) -- Select wallpaper to apply
hl.bind(mainMod .. " + SHIFT + W", exec(UserScripts .. "/WallpaperEffects.sh")) -- Wallpaper Effects by imagemagick
hl.bind("CTRL + ALT + W", exec(UserScripts .. "/WallpaperRandom.sh")) -- Random wallpapers
-- Toggle the "opaque" tag; the matching rule in WindowRules.lua disables opacity
hl.bind(mainMod .. " + ALT + O", hl.dsp.window.tag({ tag = "opaque" }))
hl.bind(mainMod .. " + SHIFT + K", exec(scriptsDir .. "/KeyBinds.sh")) -- searchable keybinds
-- Waybar / Bar related
hl.bind(mainMod .. " + B", exec("pkill -SIGUSR1 waybar")) -- Toggle hide/show waybar
hl.bind(mainMod .. " + CTRL + B", exec(scriptsDir .. "/WaybarStyles.sh")) -- Waybar Styles Menu
hl.bind(mainMod .. " + ALT + B", exec(scriptsDir .. "/WaybarLayout.sh")) -- Waybar Layout Menu

-- Master Layout
hl.bind(mainMod .. " + CTRL + D", hl.dsp.layout("removemaster"))
hl.bind(mainMod .. " + I", hl.dsp.layout("addmaster"))
hl.bind(mainMod .. " + J", hl.dsp.layout("cyclenext"))
hl.bind(mainMod .. " + K", hl.dsp.layout("cycleprev"))
hl.bind(mainMod .. " + M", hl.dsp.layout("splitratio 0.3"))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + CTRL + Return", hl.dsp.layout("swapwithmaster"))

-- group
hl.bind(mainMod .. " + G", hl.dsp.group.toggle())
hl.bind(mainMod .. " + CTRL + tab", hl.dsp.group.next()) -- change focus to another window

-- Cycle windows if floating bring to top
hl.bind("ALT + tab", function()
    hl.dispatch(hl.dsp.window.cycle_next())
    hl.dispatch(hl.dsp.window.bring_to_top())
end)

-- Special Keys / Hot Keys
hl.bind("xf86audioraisevolume", exec(scriptsDir .. "/Volume.sh --inc"), { locked = true, repeating = true }) -- volume up
hl.bind("xf86audiolowervolume", exec(scriptsDir .. "/Volume.sh --dec"), { locked = true, repeating = true }) -- volume down
hl.bind("xf86AudioMicMute", exec(scriptsDir .. "/Volume.sh --toggle-mic"), { locked = true }) -- mute mic
hl.bind("xf86audiomute", exec(scriptsDir .. "/Volume.sh --toggle"), { locked = true })
hl.bind("xf86Sleep", exec("systemctl suspend"), { locked = true }) -- sleep button
hl.bind("xf86Rfkill", exec(scriptsDir .. "/AirplaneMode.sh"), { locked = true }) -- Airplane mode

-- media controls using keyboards
hl.bind("xf86AudioPause", exec(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("xf86AudioPlay", exec(scriptsDir .. "/MediaCtrl.sh --pause"), { locked = true })
hl.bind("xf86AudioNext", exec(scriptsDir .. "/MediaCtrl.sh --nxt"), { locked = true })
hl.bind("xf86AudioPrev", exec(scriptsDir .. "/MediaCtrl.sh --prv"), { locked = true })
hl.bind("xf86audiostop", exec(scriptsDir .. "/MediaCtrl.sh --stop"), { locked = true })

-- Screenshot keybindings  NOTE: You may need to press Fn key as well
hl.bind(mainMod .. " + Print", exec(scriptsDir .. "/ScreenShot.sh --now"))
hl.bind(mainMod .. " + SHIFT + Print", exec(scriptsDir .. "/ScreenShot.sh --area"))
hl.bind(mainMod .. " + CTRL + Print", exec(scriptsDir .. "/ScreenShot.sh --in5")) -- screenshot in 5 secs
hl.bind(mainMod .. " + CTRL + SHIFT + Print", exec(scriptsDir .. "/ScreenShot.sh --in10")) -- screenshot in 10 secs
hl.bind("ALT + Print", exec("hyprshot -m window --clipboard-only"))

-- screenshot with swappy (another screenshot tool)
hl.bind(mainMod .. " + SHIFT + S", exec(scriptsDir .. "/ScreenShot.sh --swappy"))

-- Resize windows
hl.bind(mainMod .. " + SHIFT + h", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + l", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + j", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + k", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })

-- Move windows
hl.bind(mainMod .. " + CTRL + h", hl.dsp.window.move({ direction = "l" }))
hl.bind(mainMod .. " + CTRL + l", hl.dsp.window.move({ direction = "r" }))
hl.bind(mainMod .. " + CTRL + j", hl.dsp.window.move({ direction = "u" }))
hl.bind(mainMod .. " + CTRL + k", hl.dsp.window.move({ direction = "d" }))

-- Move focus with mainMod + h/j/k/l
hl.bind(mainMod .. " + h", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + l", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + j", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + k", hl.dsp.focus({ direction = "d" }))

-- Workspaces related
hl.bind(mainMod .. " + tab", hl.dsp.focus({ workspace = "m+1" }))
hl.bind(mainMod .. " + SHIFT + tab", hl.dsp.focus({ workspace = "m-1" }))

-- Special workspace
hl.bind(mainMod .. " + SHIFT + U", hl.dsp.window.move({ workspace = "special", follow = true }))
hl.bind(mainMod .. " + U", hl.dsp.workspace.toggle_special())

-- The following mappings use the key codes to better support various keyboard layouts
-- 1 is code:10, 2 is code 11, etc
for i = 1, 10 do
    local key = " + code:" .. (i + 9)
    -- Switch workspaces with mainMod + [0-9]
    hl.bind(mainMod .. key, hl.dsp.focus({ workspace = i }))
    -- Move active window and follow to workspace mainMod + SHIFT [0-9]
    hl.bind(mainMod .. " + SHIFT" .. key, hl.dsp.window.move({ workspace = i, follow = true }))
    -- Move active window to a workspace silently mainMod + CTRL [0-9]
    hl.bind(mainMod .. " + CTRL" .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end
hl.bind(mainMod .. " + SHIFT + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = true })) -- brackets [ or ]
hl.bind(mainMod .. " + SHIFT + bracketright", hl.dsp.window.move({ workspace = "+1", follow = true }))
hl.bind(mainMod .. " + CTRL + bracketleft", hl.dsp.window.move({ workspace = "-1", follow = false })) -- brackets [ or ]
hl.bind(mainMod .. " + CTRL + bracketright", hl.dsp.window.move({ workspace = "+1", follow = false }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + period", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + comma", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
