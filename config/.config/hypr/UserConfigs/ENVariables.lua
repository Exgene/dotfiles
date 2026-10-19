hl.env("EDITOR", "nvim")
-- hl.env("HYPRCURSOR_THEME", "rose-pine-hyprcursor")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")

-- xwayland apps scale fix (useful if you are use monitor scaling)
-- see https://wiki.hypr.land/Configuring/XWayland/
-- toolkit-specific scale
-- hl.env("GDK_SCALE", "1")

-- firefox
hl.env("MOZ_ENABLE_WAYLAND", "1")

-- electron >28 apps (may help)
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "x11")

-- NVIDIA
-- See hyprland wiki https://wiki.hypr.land/Nvidia/#environment-variables
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")

-- For newer Hyprland versions, you might need to add:
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- additional ENV's for nvidia. Caution, activate with care
-- hl.env("GBM_BACKEND", "nvidia-drm")

-- hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
-- hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")
-- hl.env("WLR_DRM_NO_ATOMIC", "1")

-- FOR VM and POSSIBLY NVIDIA
-- LIBGL_ALWAYS_SOFTWARE software mesa rendering
-- hl.env("LIBGL_ALWAYS_SOFTWARE", "1")
-- hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")

-- nvidia firefox (for hardware acceleration on FF)?
-- check this post https://github.com/elFarto/nvidia-vaapi-driver#configuration
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")
hl.env("EGL_PLATFORM", "wayland")
