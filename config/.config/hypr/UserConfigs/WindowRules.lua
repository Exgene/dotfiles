-- Rules are evaluated top to bottom; for conflicting effects the last match wins.
-- `move` / `size` take monitor-local expressions, e.g. "monitor_w*0.5".

local function pct(w, h) return { "monitor_w*" .. w, "monitor_h*" .. h } end

-- hl.window_rule({ match = { class = "pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol" }, center = true })
-- hl.window_rule({ match = { class = "[Ww]hatsapp-for-linux" }, center = true })
-- hl.window_rule({ match = { class = "[Ff]erdium" }, center = true })

hl.window_rule({ match = { class = "^([Tt]hunar)$", title = "(File Operation Progress)" }, float = true, center = true })
hl.window_rule({ match = { class = "^([Tt]hunar)$", title = "(Confirm to replace files)" }, float = true, center = true })
hl.window_rule({ match = { title = "^(ROG Control)$" }, float = true, center = true, size = pct(0.6, 0.7) })
hl.window_rule({ match = { title = "^(Keybindings)$" }, center = true })
hl.window_rule({
    match = { title = "^(Picture-in-Picture)$" },
    float = true, pin = true, keep_aspect_ratio = true,
    move = pct(0.72, 0.07), size = pct(0.25, 0.25),
})
hl.window_rule({
    match = { title = "^(Firefox)$" },
    float = true, pin = true,
    move = pct(0.72, 0.07), size = pct(0.25, 0.25),
})

-- rule to avoid idle for fullscreen apps
hl.window_rule({ match = { class = ".*" }, idle_inhibit = "fullscreen" })

-- SUPER ALT O toggles the "opaque" tag on the active window
hl.window_rule({ match = { tag = "opaque" }, opaque = true })

-- rule move to workspace
-- hl.window_rule({ match = { class = "^([Ff]irefox|org.mozilla.firefox|[Ff]irefox-esr)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^([Mm]icrosoft-edge(-stable|-beta|-dev|-unstable)?)$" }, workspace = "1", size = pct(0.15, 0.15) })
-- hl.window_rule({ match = { class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$" }, workspace = "1" })
-- hl.window_rule({ match = { class = "^([Tt]horium-browser)$" }, workspace = "2" })
hl.window_rule({ match = { class = "^([Tt]hunar)$" }, workspace = "3" })

-- rule move to workspace (silent)
hl.window_rule({ match = { class = "^(virt-manager)$" }, workspace = "6 silent" })
hl.window_rule({ match = { class = "^([Aa]udacious)$" }, workspace = "9 silent" })

-- rule - float
local floating = {
    { class = "^(org.kde.polkit-kde-authentication-agent-1)$" },
    { class = "([Zz]oom|onedriver|onedriver-launcher)" },
    { class = "(xdg-desktop-portal-gtk)" },
    { class = "(org.gnome.Calculator)", title = "(Calculator)" },
    { class = "(codium|codium-url-handler|VSCodium|code-oss)" },
    { class = "(electron)", title = "(Add Folder to Workspace)" },
    { class = "^([Rr]ofi)$" },
    { class = "^(eog|org.gnome.Loupe)$" }, -- image viewer
    { class = "^(pavucontrol|org.pulseaudio.pavucontrol|com.saivert.pwvucontrol)$" },
    { class = "^(nwg-look|qt5ct|qt6ct)$" },
    { class = "^(mpv|com.github.rafostar.Clapper)$" },
    { class = "^(nm-applet|nm-connection-editor|blueman-manager)$" },
    { class = "^([Yy]ad)$" },
    { class = "^(wihotspot(-gui)?)$" }, -- wifi hotspot
    { class = "^(evince)$" }, -- document viewer
    { class = "^([Bb]aobab|org.gnome.[Bb]aobab)$" }, -- Disk usage analyzer
    { title = "(Kvantum Manager)" },
    -- every Steam window except the main client
    { class = "^([Ss]team)$", title = "negative:^[Ss]team$" },
    { class = "^([Qq]alculate-gtk)$" },
}
for _, match in ipairs(floating) do
    hl.window_rule({ match = match, float = true })
end

hl.window_rule({ match = { class = "^(nm-connection-editor)$" }, center = true, size = pct(0.5, 0.6) })
hl.window_rule({ match = { initial_title = "^(Wi-Fi|Bluetooth)$" }, float = true, center = true, size = { 720, 520 } })
hl.window_rule({
    match = { class = "^(gnome-system-monitor|org.gnome.SystemMonitor|io.missioncenter.MissionCenter)$" }, -- system monitor
    float = true, size = pct(0.7, 0.7),
})
hl.window_rule({ match = { class = "^(file-roller|org.gnome.FileRoller)$" }, float = true, size = pct(0.6, 0.7) }) -- archive manager
hl.window_rule({ match = { class = "^([Ff]erdium)$" }, float = true, size = pct(0.6, 0.7) })

hl.window_rule({ match = { title = "^([kK]itty)$" }, workspace = "1" })
hl.window_rule({ match = { title = "^([zZ]en)$" }, workspace = "2" })
hl.window_rule({ match = { title = "^([Oo]bsidian)$" }, workspace = "3" })
hl.window_rule({ match = { title = "^([Yy]outube)$" }, workspace = "10" })

-- rule - size
hl.window_rule({ match = { class = "^(xdg-desktop-portal-gtk)$" }, size = pct(0.7, 0.7) })
hl.window_rule({ match = { title = "(Kvantum Manager)" }, size = pct(0.6, 0.7) })
hl.window_rule({ match = { class = "^(qt6ct)$" }, size = pct(0.6, 0.7) })
hl.window_rule({ match = { class = "^(evince|wihotspot(-gui)?)$" }, size = pct(0.7, 0.7) })
-- hl.window_rule({ match = { class = "^([Ww]hatsapp-for-linux)$" }, size = pct(0.6, 0.7) })

-- hl.window_rule({ match = { fullscreen = true }, border_color = "rgb(EE4B55) rgb(880808)" })
-- hl.window_rule({ match = { float = true }, border_color = "rgb(282737) rgb(1E1D2D)" })
-- hl.window_rule({ match = { pin = true }, opacity = "0.8 0.8" })

-- LAYER RULES
-- hl.layer_rule({ match = { namespace = "^([Rr]ofi)$" }, blur = true })
-- hl.layer_rule({ match = { namespace = "rofi" }, ignore_alpha = 0 })
-- hl.layer_rule({ match = { namespace = "overview" }, blur = true, ignore_alpha = 0 })
