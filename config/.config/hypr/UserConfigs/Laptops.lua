local scriptsDir = os.getenv("HOME") .. "/.config/hypr/scripts"

-- Keep in sync with TOUCHPAD_DEVICE in scripts/TouchPad.sh
local Touchpad_Device = "asue1209:00-04f3:319f-touchpad"

hl.bind("xf86KbdBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --dec"), { repeating = true }) -- Keyboard brightness Down
hl.bind("xf86KbdBrightnessUp", hl.dsp.exec_cmd(scriptsDir .. "/BrightnessKbd.sh --inc"), { repeating = true }) -- Keyboard brightness up
hl.bind("xf86Launch1", hl.dsp.exec_cmd("rog-control-center")) -- ASUS Armory crate button
hl.bind("xf86Launch3", hl.dsp.exec_cmd("asusctl led-mode -n")) -- FN+F4 Switch keyboard RGB profile
hl.bind("xf86Launch4", hl.dsp.exec_cmd("asusctl profile -n")) -- FN+F5 change of fan profiles (Quite, Balance, Performance)
hl.bind("xf86MonBrightnessDown", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --dec"), { repeating = true })
hl.bind("xf86MonBrightnessUp", hl.dsp.exec_cmd(scriptsDir .. "/Brightness.sh --inc"), { repeating = true })
hl.bind("xf86TouchpadToggle", hl.dsp.exec_cmd(scriptsDir .. "/TouchPad.sh")) -- disable touchpad

hl.device({
    name = Touchpad_Device,
    enabled = true,
})
