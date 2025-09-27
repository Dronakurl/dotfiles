-- Pull in the wezterm API

local wezterm = require("wezterm")

-- local mux = wezterm.mux
-- wezterm.on('gui-startup', function(cmd)
-- 	local tab, pane, window = mux.spawn_window(cmd or {})
-- 	window:gui_window():maximize()
-- end)

-- This will hold the configuration.
local config = wezterm.config_builder()

local act = wezterm.action
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = { WheelUp = 1 } } },
		mods = "NONE",
		-- action = act.ScrollByLine(-0.1),
		action = act.ScrollByPage(-0.2),
		alt_screen = false,
	},
	{
		event = { Down = { streak = 1, button = { WheelDown = 1 } } },
		mods = "NONE",
		-- action = act.ScrollByLine(0.1),
		action = act.ScrollByPage(0.2),
		alt_screen = false,
	},
}

-- local act = wezterm.action
-- config.mouse_bindings = {
-- 	-- Bind 'Up' event of CTRL-Click to open hyperlinks
-- 	{
-- 		event = { Up = { streak = 1, button = "Left" } },
-- 		mods = "CTRL",
-- 		action = act.OpenLinkAtMouseCursor,
-- 	},
-- 	-- Disable the 'Down' event of CTRL-Click to avoid weird program behaviors
-- 	{
-- 		event = { Down = { streak = 1, button = "Left" } },
-- 		mods = "CTRL",
-- 		action = act.Nop,
-- 	},
-- }

-- config.alternate_buffer_wheel_scroll_speed = 1

-- config.color_scheme = "Catppuccin Mocha"
config.color_scheme = "Tokyo Night"
-- config.color_scheme = "terafox"
config.enable_tab_bar = false
config.window_decorations = "NONE"
-- Set background transparency
config.window_background_opacity = 0.95
config.warn_about_missing_glyphs = false

-- config.font = wezterm.font("Radon")
-- config.font = wezterm.font("Krypton")
-- config.font = wezterm.font("Neon")

config.font = wezterm.font("JetBrains Mono")
config.font_size = 12.0
-- config.line_height = 1.05

-- config.font = wezterm.font("CommitMono")
-- config.font = wezterm.font("UbuntuMono Nerd Font")
-- config.font = wezterm.font("Iosevka Nerd Font Mono")
-- config.font = wezterm.font("CodeNewRoman Nerd Font Mono")
-- config.line_height = 1.05
-- config.font = wezterm.font("Agave Nerd Font Mono")

-- config.scrollback_lines = 3500

-- config.font = wezterm.font("Neon")
-- config.font_rules = {
-- 	{
-- 		italic = true,
-- 		font = wezterm.font("Radon"),
-- 	},
-- 	{
-- 		intensity = "Bold",
-- 		font = wezterm.font({
-- 			family = "Krypton",
-- 			weight = "Bold",
-- 		}),
-- 	},
-- }

config.colors = { background = "#000000" }

-- config.text_background_opacity = 0.3
-- and finally, return the configuration to wezterm

config.window_padding = {
	left = 3,
	right = 3,
	top = 3,
	bottom = 3,
}

config.window_frame = {
	border_left_width = "0.3cell",
	border_right_width = "0.3cell",
	border_bottom_height = "0.14cell",
	border_top_height = "0.13cell",
	border_left_color = "rgba(50, 49, 137, 1)",
	border_right_color = "rgba(50, 49, 137, 1)",
	border_bottom_color = "rgba(50, 49, 137, 1)",
	border_top_color = "rgba(50, 49, 137, 1)",
}

wezterm.on("toggle-tabbar", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if overrides.enable_tab_bar == false then
		wezterm.log_info("tab bar shown")
		overrides.enable_tab_bar = true
	else
		wezterm.log_info("tab bar hidden")
		overrides.enable_tab_bar = false
	end
	window:set_config_overrides(overrides)
end)

config.leader = { key = "b", mods = "ALT", timeout_milliseconds = 1001 }

config.enable_csi_u_key_encoding = true
-- -- unbind CTRL+M
-- config.disable_default_key_bindings = true

config.keys = {
	-- { key = "r", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
	-- { key = "r", mods = "CTRL|SHIFT", action = act.SendKey({ key = "r", mods = "CTRL|SHIFT" }) },
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
	{ key = "b", mods = "LEADER", action = act.SendKey({ key = "b", mods = "CTRL" }) },
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "ALT" }) },
	{ key = "t", mods = "LEADER", action = act.EmitEvent("toggle-tabbar") },
	{
		key = ".",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Window management
	-- { key = "a", mods = "LEADER", action = act({ SendString = "`" }) },
	{ key = "-", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "s", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },

	{ key = "h", mods = "LEADER", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "LEADER", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "LEADER", action = act.ActivatePaneDirection("Right") },

	{ key = "o", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
	{ key = "H", mods = "LEADER", action = act({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER", action = act({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER", action = act({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER", action = act({ AdjustPaneSize = { "Right", 5 } }) },

	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "1", mods = "LEADER", action = act({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = act({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = act({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = act({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = act({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = act({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = act({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = act({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = act({ ActivateTab = 8 }) },
	{ key = "x", mods = "LEADER", action = act({ CloseCurrentPane = { confirm = true } }) },

	-- Activate Copy Mode
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	-- Paste from Copy Mode
	{ key = "]", mods = "LEADER", action = act.PasteFrom("PrimarySelection") },
	{
		key = "b",
		mods = "LEADER",
		action = wezterm.action.EmitEvent("toggle-opacity"),
	},
	{
		key = "m",
		mods = "LEADER",
		action = wezterm.action.ShowLauncher,
	},
	{
		key = "e",
		mods = "LEADER",
		action = wezterm.action.CharSelect({
			copy_on_select = true,
			copy_to = "ClipboardAndPrimarySelection",
		}),
	},
}
config.use_fancy_tab_bar = false
config.colors = {
	tab_bar = {
		active_tab = {
			bg_color = "cornflowerblue",
			fg_color = "black",
		},
	},
}

-- wezterm.on("gui-startup", function(cmd)
-- 	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
-- 	window:gui_window():maximize()
-- end)

wezterm.on("toggle-opacity", function(window, pane)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.80
	elseif overrides.window_background_opacity == 0.80 then
		overrides.window_background_opacity = 0.95
	elseif overrides.window_background_opacity == 0.95 then
		overrides.window_background_opacity = 1.0
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

return config
