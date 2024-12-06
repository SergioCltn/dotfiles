local wezterm = require("wezterm")
local act = wezterm.action

-- This will hold the configuration.
local config = wezterm.config_builder()

config = {
	font_size = 12,
	color_scheme = "Bamboo",
	enable_tab_bar = false,
	macos_window_background_blur = 10,
	-- font = wezterm.font("CaskaydiaCove Nerd Font Mono"),
	-- font = wezterm.font_with_fallback({}),

	-- font = wezterm.font("Cascadia Mono"),

	automatically_reload_config = true,
	scrollback_lines = 10000,

	-- window
	window_background_opacity = 0.95,
	window_decorations = "RESIZE",

	-- Cursor
	default_cursor_style = "BlinkingUnderline",
	cursor_blink_rate = 1000,
	colors = {
		foreground = "#CBE0F0",
		background = "#011423",
		cursor_bg = "#47FF9C",
		cursor_border = "#47FF9C",
		cursor_fg = "#011423",
		selection_bg = "#033259",
		selection_fg = "#CBE0F0",
		ansi = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#0FC5ED", "#a277ff", "#24EAF7", "#24EAF7" },
		brights = { "#214969", "#E52E2E", "#44FFB1", "#FFE073", "#A277FF", "#a277ff", "#24EAF7", "#24EAF7" },
	},

	-- disable_default_key_bindings = true,
	-- Keys
	keys = {
		-- Send the Ctrl+ShiftTab key combination to the terminal
		{ key = "h", mods = "CMD|SHIFT", action = wezterm.action({ ActivateTabRelative = -1 }) },
		{ key = "l", mods = "CMD|SHIFT", action = wezterm.action({ ActivateTabRelative = 1 }) },
		{ key = "LeftArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
		{ key = "RightArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
		{ key = "UpArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
		{ key = "DownArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
		{ key = "m", mods = "ALT", action = wezterm.action.TogglePaneZoomState },

		-- shell to redraw its prompt
		{
			key = "K",
			mods = "CMD|SHIFT",
			action = act.Multiple({
				act.ClearScrollback("ScrollbackAndViewport"),
				act.SendKey({ key = "L", mods = "CTRL" }),
			}),
		},
		-- Create a new split and run your default program inside it
		{
			key = "d",
			mods = "CMD",
			action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "d",
			mods = "CMD | SHIFT",
			action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},

		-- Close the current pane
		-- If tis the only one in the tab will close the tab
		{
			key = "w",
			mods = "CMD",
			action = wezterm.action.CloseCurrentPane({ confirm = true }),
		},

		-- Switch panes with CMD + Arrow
		{
			key = "h",
			mods = "CMD",
			action = act.ActivatePaneDirection("Left"),
		},
		{
			key = "l",
			mods = "CMD",
			action = act.ActivatePaneDirection("Right"),
		},
		{
			key = "k",
			mods = "CMD",
			action = act.ActivatePaneDirection("Up"),
		},
		{
			key = "j",
			mods = "CMD",
			action = act.ActivatePaneDirection("Down"),
		},
	},

	-- Mouse
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
	},
	pane_focus_follows_mouse = true,
}

return config
