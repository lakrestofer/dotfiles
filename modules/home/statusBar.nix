{ ... }:
{
  flake.homeModules.statusBarModule =
    { lib, config, ... }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      inherit (lib) map mergeAttrsList;

      # paths
      configRoot = "${config.home.homeDirectory}/dotfiles/modules/home";

      # utils
      # links ~/dotfiles/home/${name} to ~/config/${name}
      linkConfFiles = map (name: {
        ${name}.source = mkOutOfStoreSymlink "${configRoot}/${name}";
      });

    in

    {
      # programs.ashell.enable = true;
      xdg.configFile = mergeAttrsList (linkConfFiles [
        "waybar"
        "ashell"
      ]);

      stylix.targets.waybar.enable = false;

    };

  flake.nixosModules.statusBarModule =
    { pkgs, ... }:
    {
      environment.systemPackages = (
        with pkgs;
        [
          waybar
          ashell
        ]
      );

    };
}
