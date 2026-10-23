-- Hyprland Lua configuration

-------------------
-- My Programs
-------------------

local terminal = "ghostty"
local fileManager = "uwsm-app -- nautilus --new-window"
local menu = "uwsm-app -- rofi -show drun"
local browser = "brave --force-device-scale-factor=0.95"
local binaries = os.getenv("HOME") .. "/.local/bin"
local mainMod = "SUPER"

-------------------
-- Monitors
-------------------

hl.monitor({ output = "DP-1", mode = "preferred", position = "0x0", scale = "1" })
hl.monitor({ output = "eDP-1", mode = "preferred", position = "0x1080", scale = "1" })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = "1" })

for workspace = 1, 5 do
    hl.workspace_rule({ workspace = tostring(workspace), persistent = true })
end

-------------------
-- Autostart
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("uwsm-app -- hypridle")
    hl.exec_cmd("uwsm-app -- mako")
    hl.exec_cmd("uwsm-app -- waybar")
    hl.exec_cmd("uwsm-app -- hyprpaper")
    hl.exec_cmd("uwsm-app -- hyprsunset")
    hl.exec_cmd("uwsm-app -- wl-paste --type text --watch cliphist store")
    hl.exec_cmd("uwsm-app -- wl-paste --type image --watch cliphist store")
    hl.exec_cmd("systemctl --user start hyprpolkitagent.service")

    hl.exec_cmd('gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"')
    hl.exec_cmd("gsettings set org.gnome.desktop.interface font-name 'Inter 11'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface document-font-name 'Inter 11'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 10'")
    hl.exec_cmd("gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Inter Bold 11'")
end)

-- Environment variables live in ~/.config/uwsm/env so every session app inherits them.

-------------------
-- Look And Feel
-------------------

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 5,
        border_size = 2,
        col = {
            active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
            inactive_border = "rgba(595959aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(1a1a1aee)",
        },

        blur = {
            enabled = true,
            size = 6,
            passes = 2,
            vibrancy = 0.2,
        },
    },

    animations = {
        enabled = true,
    },

    dwindle = {
        preserve_split = true,
    },

    master = {
        new_status = "master",
    },

    misc = {
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
        disable_hyprland_logo = true,
    },

    input = {
        kb_layout = "us",
        repeat_delay = 270,
        repeat_rate = 35,
        follow_mouse = 1,
        sensitivity = 0,

        touchpad = {
            natural_scroll = true,
        },
    },
})

-- Blur the desktop behind Waybar; its translucent CSS provides the glass tint.
hl.layer_rule({
    name = "waybar-liquid-glass",
    match = { namespace = "^waybar$" },
    blur = true,
    blur_popups = true,
    ignore_alpha = 0.12,
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 2, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 1.5, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.5, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 1.5, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.5, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.5, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1, bezier = "almostLinear", style = "fade" })

hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })

-------------------
-- Keybindings
-------------------

local function bind(keys, dispatcher, description, options)
    local opts = options or {}
    opts.description = description
    hl.bind(keys, dispatcher, opts)
end

-- Applications
bind(mainMod .. " + T", hl.dsp.exec_cmd(binaries .. "/hyprland-launch-or-focus " .. terminal), "Open terminal")
bind(mainMod .. " + SHIFT + T", hl.dsp.exec_cmd("uwsm-app -- " .. terminal), "Open new terminal")
bind(mainMod .. " + B", hl.dsp.exec_cmd(binaries .. "/hyprland-launch-or-focus ^brave " .. browser), "Open browser")
bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager), "Open file manager")
bind(mainMod .. " + Space", hl.dsp.exec_cmd(menu), "Open app launcher")
bind(mainMod .. " + SHIFT + slash", hl.dsp.exec_cmd(binaries .. "/hyprland-launch-keybinds"), "Show keybindings")
bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p Clipboard -display-columns 2 | cliphist decode | wl-copy"), "Clipboard history")

-- Window management
bind(mainMod .. " + Q", hl.dsp.window.close(), "Close window")
bind(mainMod .. " + V", hl.dsp.window.float(), "Toggle floating")
bind(mainMod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }), "Toggle maximize")
bind(mainMod .. " + P", hl.dsp.window.pseudo(), "Toggle pseudo-tile")
bind(mainMod .. " + S", hl.dsp.layout("togglesplit"), "Toggle split")

-- Session
bind(mainMod .. " + Escape", hl.dsp.exec_cmd("loginctl lock-session"), "Lock screen")
bind(mainMod .. " + equal", hl.dsp.exec_cmd("uwsm stop"), "Exit Hyprland")

-- Focus (vim keys)
bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), "Focus left")
bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), "Focus right")
bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), "Focus up")
bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), "Focus down")

-- Focus (arrow keys)
bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }), "Focus left")
bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }), "Focus right")
bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }), "Focus up")
bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }), "Focus down")

-- Focus monitor
bind(mainMod .. " + CTRL + left", hl.dsp.focus({ monitor = "l" }), "Focus monitor left")
bind(mainMod .. " + CTRL + right", hl.dsp.focus({ monitor = "r" }), "Focus monitor right")
bind(mainMod .. " + CTRL + up", hl.dsp.focus({ monitor = "u" }), "Focus monitor up")
bind(mainMod .. " + CTRL + down", hl.dsp.focus({ monitor = "d" }), "Focus monitor down")

-- Move workspace to monitor
bind(mainMod .. " + SHIFT + H", hl.dsp.workspace.move({ monitor = "l" }), "Move workspace left")
bind(mainMod .. " + SHIFT + L", hl.dsp.workspace.move({ monitor = "r" }), "Move workspace right")
bind(mainMod .. " + SHIFT + J", hl.dsp.workspace.move({ monitor = "d" }), "Move workspace down")
bind(mainMod .. " + SHIFT + K", hl.dsp.workspace.move({ monitor = "u" }), "Move workspace up")

-- Move window in direction
bind(mainMod .. " + ALT + H", hl.dsp.window.move({ direction = "left" }), "Move window left")
bind(mainMod .. " + ALT + L", hl.dsp.window.move({ direction = "right" }), "Move window right")
bind(mainMod .. " + ALT + K", hl.dsp.window.move({ direction = "up" }), "Move window up")
bind(mainMod .. " + ALT + J", hl.dsp.window.move({ direction = "down" }), "Move window down")

-- Move window to adjacent workspace
bind(mainMod .. " + ALT + left", hl.dsp.window.move({ workspace = "-1" }), "Move to prev workspace")
bind(mainMod .. " + ALT + right", hl.dsp.window.move({ workspace = "+1" }), "Move to next workspace")

-- Resize windows
bind(mainMod .. " + CTRL + H", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), "Resize left")
bind(mainMod .. " + CTRL + L", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), "Resize right")
bind(mainMod .. " + CTRL + K", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), "Resize up")
bind(mainMod .. " + CTRL + J", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), "Resize down")

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = tostring(i) }), "Workspace " .. i)
    bind(mainMod .. " + ALT + " .. key, hl.dsp.window.move({ workspace = tostring(i) }), "Move to workspace " .. i)
end

-- Workspace scroll
bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), "Next workspace")
bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }), "Previous workspace")

-- Mouse bindings
bind("ALT + mouse:272", hl.dsp.window.drag(), "Move window with mouse", { mouse = true })
bind("ALT + mouse:273", hl.dsp.window.resize(), "Resize window with mouse", { mouse = true })

-- Media keys
bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), "Volume up", { locked = true, repeating = true })
bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), "Volume down", { locked = true, repeating = true })
bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), "Toggle audio mute", { locked = true })
bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), "Toggle microphone mute", { locked = true })
bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), "Brightness up", { locked = true, repeating = true })
bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), "Brightness down", { locked = true, repeating = true })

-- Media controls
bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), "Next media", { locked = true })
bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), "Toggle media playback", { locked = true })
bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), "Toggle media playback", { locked = true })
bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), "Previous media", { locked = true })

-- Screenshots
bind("Print", hl.dsp.exec_cmd(binaries .. "/hyprland-cmd-screenshot smart"), "Screenshot and edit")
bind("CTRL + SHIFT + 3", hl.dsp.exec_cmd(binaries .. "/hyprland-cmd-screenshot fullscreen clipboard"), "Screenshot screen to clipboard")
bind("CTRL + SHIFT + 4",hl.dsp.exec_cmd(binaries .. "/hyprland-cmd-screenshot smart clipboard"), "Screenshot to clipboard")
bind("CTRL + SHIFT + 5", hl.dsp.exec_cmd(binaries .. "/hyprland-screenrecord"), "Screen record")

-------------------
-- Window Rules
-------------------

hl.window_rule({
    name = "floating-tui",
    match = { class = [[^org\.hyprland\..*]] },
    float = true,
    size = "1200 800",
})

hl.window_rule({
    name = "popups",
    match = { class = "org.gnome.Loupe" },
    float = true,
})

hl.window_rule({
    name = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name = "fix-xwayland-drags",
    match = {
        class = "^$",
        title = "^$",
        xwayland = true,
        float = true,
        fullscreen = false,
        pin = false,
    },
    no_focus = true,
})
