hl.monitor({ output = "eDP-1", mode = "2560x1440@165", position = "auto", scale = 1.33 })
-- hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.33, cm = "auto", sdrsaturation = 0.6 })
-- hl.monitor({ output = "eDP-1", disabled = true })
-- hl.monitor({ output = "eDP-2", disabled = true })
-- hl.monitor({ output = "DP-3", mode = "1920x1080@240", position = "auto", scale = 1 })
-- hl.monitor({ output = "DP-1", mode = "preferred", position = "auto", scale = 1 })
-- hl.monitor({ output = "HDMI-A-1", mode = "preferred", position = "auto", scale = 1 })
-- hl.monitor({ output = "HDMI-A-1", disabled = true })

-- QEMU-KVM, virtual box or vmware
-- hl.monitor({ output = "Virtual-1", mode = "1920x1080@60", position = "auto", scale = 1 })

-- Fallback for any other monitor: high refresh rate, then high resolution
hl.monitor({ output = "", mode = "highrr", position = "auto", scale = 1 })
hl.monitor({ output = "", mode = "highres", position = "auto", scale = 1 })

-- Mirror samples
-- hl.monitor({ output = "DP-3", mode = "1920x1080@60", position = "0x0", scale = 1, mirror = "DP-2" })
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, mirror = "eDP-1" })
-- hl.monitor({ output = "HDMI-A-1", mode = "2560x1440@144", position = "0x0", scale = 1, mirror = "eDP-1" })

-- 10 bit monitor support - See wiki https://wiki.hypr.land/Configuring/Basics/Monitors/#10-bit-support
-- NOTE: Colors registered in Hyprland (e.g. the border color) do not support 10 bit.
-- NOTE: Some applications do not support screen capture with 10 bit enabled. (Screen captures like OBS may render black screen)
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, bitdepth = 10 })

-- hl.monitor({ output = "eDP-1", transform = 0 })
-- hl.monitor({ output = "eDP-1", reserved_area = { top = 10, right = 10, bottom = 10, left = 49 } })
