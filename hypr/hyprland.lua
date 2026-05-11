-- ──────────────────────────────────────────────────────────────────────────
--  °˖* ૮(  • ᴗ ｡)っ🍸  pewdiepie/archdaemon/dionysh shhheersh
--  Hyprland config 
--  vers. 1.0 (Lua Migration)
-- ──────────────────────────────────────────────────────────────────────────

local terminal = "alacritty"
local fileManager = "nautilus"
local menu = "rofi"
local mod = "SUPER"

hl.monitor({
    output = "eDP-1",
    mode = "2560x1600@165",
    position = "auto",
    scale =  "1.25",
})

-- ── MAIN CONFIGURATION ────────────────────────────────────────────────────
hl.config({

  -- Note: exec_once moved to the bottom of the file using hl.on("hyprland.start")
  
  env = {
    "XCURSOR_SIZE,25",
    "HYPRCURSOR_SIZE,25",
    "XDG_CURRENT_DESKTOP,Hyprland",
    "GDK_DPI_SCALE,1",
    "XFT_DPI,96",
    "XFT_FONT,GohuFont-11",
    "LIBVA_DRIVER_NAME,nvidia",
    "__GLX_VENDOR_LIBRARY_NAME,nvidia",
    "ELECTRON_OZONE_PLATFORM_HINT,auto",
    "NVD_BACKEND,direct",
    "__GL_VRR_ALLOWED,0",
    "__GL_GSYNC_ALLOWED,0",
    "__GL_SYNC_TO_VBLANK,1"
  },
  
  xwayland = {
    force_zero_scaling = true
  },
  
  general = {
    gaps_in = 5,
    gaps_out = 20,
    border_size = 2,
    ["col.active_border"] = "rgba(61afefff)",
    ["col.inactive_border"] = "rgba(444444ff)",
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle"
  },
  
  decoration = {
    rounding = 1,
    rounding_power = 2,
    active_opacity = 1.0,
    inactive_opacity = 1.0,
    shadow = {
      enabled = true,
      range = 5,
      render_power = 4,
      color = "rgba(1fbeffee)"
    },
    blur = {
      size = 2,
      passes = 1,
      brightness = 0.4
    }
  },
  
  dwindle = {
    preserve_split = true
  },
  
  master = {
    new_status = "master"
  },
  
  misc = {
    force_default_wallpaper = 0,
    disable_hyprland_logo = true
  },
  
  input = {
    kb_layout = "us, ru",
    kb_options = "grp:alt_shift_toggle",
    follow_mouse = 1,
    sensitivity = 0,
    touchpad = {
      natural_scroll = true
    }
  },
  
  device = {
    {
      name = "logitech-g102-lightsync-gaming-mouse",
      sensitivity = -0.75
    }
  },
  
  windowrule = {
    "suppress_event maximize, match:class .*",
    "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
  },
  
  workspace = {
    "1,persistent:true",
    "2,persistent:true",
    "3,persistent:true",
    "4,persistent:true",
    "9,persistent:true",
    "1,monitor:eDP-1",
    "2,monitor:eDP-1",
    "3,monitor:eDP-1",
    "4,monitor:eDP-1",
    "9,monitor:eDP-1"
  }
})

-- ── KEYBINDINGS ───────────────────────────────────────────────────────────

-- Fullscreen toggle
hl.bind(mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))

-- Apps
hl.bind(mod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + B", hl.dsp.exec_cmd("firefox"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mod .. " + Q", hl.dsp.window.close())
hl.bind(mod .. " + V", hl.dsp.window.float())
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd(menu .. " -show drun"))
-- Power menu
hl.bind("CTRL + ALT + DELETE", hl.dsp.exec_cmd("/home/enainandreev/.config/waybar/scripts/powermenu.sh"))

-- Screenshot (slurp | grim)
hl.bind("ALT + P", hl.dsp.exec_cmd("slurp | tee >(grim -g \"$(cat)\" \"$HOME/Pictures/Screenshots/screenshot-$(date +'%Y-%m-%d-%H%M%S').png\") | grim -g \"$(cat)\" - | wl-copy"))

-- ── ASUS KEYBOARD SCRIPTS ──────────────────────────────────────────────────
hl.bind("XF86KbdBrightnessDown", hl.dsp.exec_cmd("bash ~/.config/kbd-brightness.sh down"))
hl.bind("XF86KbdBrightnessUp",   hl.dsp.exec_cmd("bash ~/.config/kbd-brightness.sh up"))
hl.bind("XF86Launch3",           hl.dsp.exec_cmd("bash ~/.config/kbd-breathing.sh"))
hl.bind("XF86Launch4",           hl.dsp.exec_cmd("~/.config/hypr/scripts/asus-kbd/cycle-profile.sh"))

-- ── SYSTEM SCRIPTS (Waybar / Profile) ──────────────────────────────────────
hl.bind("XF86Launch1", hl.dsp.exec_cmd("~/.config/waybar/scripts/asus-profile.sh next && pkill -RTMIN+8 waybar"))

-- ── MULTIMEDIA KEYS ────────────────────────────────────────────────────────
-- Volume & Brightness (using repeating/locked flags for better feel)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })

hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl s 10%+"), { repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl s 10%-"), { repeating = true })

-- Player Control
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Move focus
hl.bind(mod .. " + left", hl.dsp.focus({ direction = "l" }))
hl.bind(mod .. " + right", hl.dsp.focus({ direction = "r" }))
hl.bind(mod .. " + up", hl.dsp.focus({ direction = "u" }))
hl.bind(mod .. " + down", hl.dsp.focus({ direction = "d" }))

-- Workspaces
hl.bind(mod .. " + 1", hl.dsp.focus({ workspace = "1" }))
hl.bind(mod .. " + 2", hl.dsp.focus({ workspace = "2" }))
hl.bind(mod .. " + 3", hl.dsp.focus({ workspace = "3" }))
hl.bind(mod .. " + 4", hl.dsp.focus({ workspace = "4" }))
hl.bind(mod .. " + 9", hl.dsp.focus({ workspace = "9" }))

hl.bind("ALT + 1", hl.dsp.window.move({ workspace = "1" }))
hl.bind("ALT + 2", hl.dsp.window.move({ workspace = "2" }))
hl.bind("ALT + 3", hl.dsp.window.move({ workspace = "3" }))
hl.bind("ALT + 4", hl.dsp.window.move({ workspace = "4" }))

-- ── 1. DEFINE CURVES FIRST ────────────────────────────────────────────────
hl.curve("easeOutQuint", { type = "bezier", points = { {0.23, 1}, {0.32, 1} } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1} } })
hl.curve("linear", { type = "bezier", points = { {0, 0}, {1, 1} } })
hl.curve("almostLinear", { type = "bezier", points = { {0.5, 0.5}, {0.75, 1.0} } })
hl.curve("quick", { type = "bezier", points = { {0.15, 0}, {0.1, 1} } })

-- ── ANIMATIONS (Application) ───────────────────────────────────────────────
-- Global and Borders
hl.animation({ leaf = "global",     enabled = true, speed = 10,   bezier = "easeOutQuint" })
hl.animation({ leaf = "border",     enabled = true, speed = 5.39, bezier = "easeOutQuint" })

-- Windows (Opening and Closing)
hl.animation({ leaf = "windows",    enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn",  enabled = true, speed = 4.1,  bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear",       style = "popin 87%" })

-- Fade Effects
hl.animation({ leaf = "fadeIn",     enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",    enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",       enabled = true, speed = 3.03, bezier = "quick" })

-- Layers (Waybar, Rofi, etc.)
hl.animation({ leaf = "layers",     enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",   enabled = true, speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",  enabled = true, speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })

-- Workspaces
hl.animation({ leaf = "workspaces",    enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" }) 

-- ── AUTOSTART ──────────────────────────────────────────────────────────────
hl.on("hyprland.start", function()
  hl.exec_cmd("~/.config/hypr/scripts/waybar_watcher.sh")
  hl.exec_cmd("firefox --new-instance", { workspace = "9 silent" })
  hl.exec_cmd("conky")
  hl.exec_cmd("systemctl --user start hyprpolkitagent")
  hl.exec_cmd("hyprpaper")
  hl.exec_cmd("bash ~/.config/kbd-brightness.sh")
end)