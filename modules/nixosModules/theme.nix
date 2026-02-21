{ ... }:
{
  flake.nixosModules.themeModule =
    { config, pkgs, ... }:
    {
      stylix.enable = true;
      stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-light-hard.yaml";

      stylix.targets.gtk.enable = true;

      stylix.fonts = {
        serif = config.stylix.fonts.monospace;
        sansSerif = config.stylix.fonts.monospace;
        monospace = {
          package = pkgs.monaspace;
          name = "Monaspace Neon";
        };
        emoji = {
          package = pkgs.noto-fonts-color-emoji;
          name = "Noto Color Emoji";
        };

      };
    };
  flake.homeModules.themeModule =
    { pkgs, pkgs-unstable, ... }:
    {
      stylix.targets.gtk.enable = true;

      stylix.targets.helix.enable = false;
      stylix.targets.zathura.enable = false;
      stylix.targets.niri.enable = false;

      qt = {
        enable = true;
        # platformTheme.name = "gtk";
        # style = {
        #   name = "gtk2";
        # };
      };
      gtk = {
        enable = true;
        # font.name = "CozetteHiDpi Medium 10";
        # colorScheme = "dark";
        # theme = {
        #   name = "Gruvbox-Dark";
        #   package = pkgs-unstable.gruvbox-gtk-theme;
        # };
        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs-unstable.gruvbox-plus-icons;
        };
        # gtk3.extraConfig = {
        #   Settings = ''
        #     gtk-application-prefer-dark-theme=1
        #   '';
        # };
        # gtk4.extraConfig = {
        #   Settings = ''
        #     gtk-application-prefer-dark-theme=1
        #   '';
        # };
      };

    };

}
