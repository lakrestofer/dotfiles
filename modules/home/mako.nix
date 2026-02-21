{ ... }:
{
  flake.homeModules.makoModule =
    { ... }:
    {
      services.mako.enable = true;

      stylix.targets.mako.enable = true;
      stylix.targets.mako.fonts.override = {
        sansSerif.name = "Monaspace Neon";
        sizes.popups = "14";
      };
      stylix.targets.mako.colors.override = {
        withHashtag = {
          base0D = "#d79921";
        };
      };

      services.mako.settings = {
        default-timeout = 4000;
        # background-color=#ebdbb2FF
        # text-color=#1d2021FF
        border-size = 4;
        # border-color=#d79921FF
        border-radius = 0;
        anchor = "top-center";
      };

    };
}
