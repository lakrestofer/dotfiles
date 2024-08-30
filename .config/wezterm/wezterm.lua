local wezterm = require 'wezterm'

local config = {}
config.enable_wayland = true;
config.window_close_confirmation = "NeverPrompt";

config.color_scheme = 'colorscheme'
config.enable_tab_bar = false;
config.use_fancy_tab_bar = false;
-- config.tab_bar_at_bottom = true;
config.font = wezterm.font 'FiraCode Nerd Font'
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.window_background_opacity = 0.6;

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}

return config
