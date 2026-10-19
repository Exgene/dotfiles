local mainMod = "SUPER"
local files = "thunar"
local term = "ghostty"
local home = os.getenv("HOME")
local scriptsDir = home .. "/.config/hypr/scripts"
local UserScripts = home .. "/.config/hypr/UserScripts"

hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("pkill rofi || rofi -show drun -modi drun,filebrowser,run,window"))

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("pkill rofi || true && ags -t 'overview'"))

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(term)) -- Launch terminal
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(files)) -- Launch file manager
hl.bind(mainMod .. " + ALT + C", hl.dsp.exec_cmd(UserScripts .. "/RofiCalc.sh")) -- calculator (qalculate)

-- User Added Keybinds
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(
    term .. " --title=Wi-Fi -e " .. home .. "/.config/waybar/scripts/network.sh",
    { float = true, center = true, size = { 720, 520 } }
))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.exec_cmd(UserScripts .. "/ZshChangeTheme.sh")) -- Change oh-my-zsh theme
-- Changing the keyboard layout
hl.bind("ALT + SHIFT_L", hl.dsp.exec_cmd(scriptsDir .. "/SwitchKeyboardLayout.sh"), { non_consuming = true })

-- For passthrough keyboard into a VM
-- hl.bind(mainMod .. " + ALT + P", hl.dsp.submap("passthru"))
-- hl.define_submap("passthru", function()
--     -- to unbind
--     hl.bind(mainMod .. " + ALT + P", hl.dsp.submap("reset"))
-- end)
