{ ... }:
{
  flake.homeModules.fuzzelModule =
    { ... }:
    {
      programs.fuzzel.enable = true;
      programs.fuzzel.settings.main = {
        dpi-aware = false;
        icons-enabled = false;
        match-mode = "fuzzy";
        sort-result = "yes";
        show-actions = "no";
        terminal = "alacritty --command";
        lines = 20;
        width = 80;
      };

      stylix.targets.fuzzel.enable = true;
      stylix.targets.fuzzel.fonts.override = {
        sansSerif.name = "Monaspace Neon";
        sizes.popups = "14";
      };
      stylix.targets.fuzzel.colors.override = {
        base0D-hex = "d79921";
      };

      programs.fuzzel.settings = {
        border = {
          width = 2;
          radius = 0;
        };
        dmenu = {
          mode = "text";
        };
        key-bindings = {
          execute-input = "Control+Return Shift+KP_Enter";
        };
      };
    };
}
