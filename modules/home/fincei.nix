{ ... }:
{

  flake.homeModules.finceiModule =
    {
      lib,
      config,
      pkgs-unstable,
      ...
    }:
    let
      inherit (config.lib.file) mkOutOfStoreSymlink;
      inherit (lib) map mergeAttrsList;

      # paths
      configRoot = "${config.home.homeDirectory}/dotfiles/modules/home";

      scriptPath = "${configRoot}/scripts";
      agentPath = "${configRoot}/agent";

      zshRoot = "${configRoot}/zsh";

      # utils
      # links ~/dotfiles/home/${name} to ~/config/${name}
      linkConfFiles = map (name: {
        ${name}.source = mkOutOfStoreSymlink "${configRoot}/${name}";
      });

      linkConf = config.lib.file.mkOutOfStoreSymlink;
    in
    {
      # basic options
      home.username = "fincei";
      home.homeDirectory = "/home/fincei";
      home.stateVersion = "24.05";
      programs.home-manager.enable = true; # allow home manager to manage itself
      # imports
      imports = [
        # ./home/zsh
      ];
      # user packages (only installed per user)
      home.packages = [ ];
      xdg.configFile = mergeAttrsList (linkConfFiles [
        "helix"
        "sioyek"
        "codebook"
        "alacritty"
        "qutebrowser"
        "ghostty"
        "zathura"
        "walker"
        "waybar"
        "hypr"
        "mako"
        "fuzzel"
        "niri"
        "swaylock"
        "scripts"
        "emacs"
        "lazygit"
        "yazi"
        "agent"
      ]);

      home.file.".local/bin".source = linkConf scriptPath;
      home.file.".zshrc".source = linkConf "${zshRoot}/zshrc.zsh";
      home.file.".zprofile".source = linkConf "${zshRoot}/zprofile.zsh";
      home.file.".p10k.zsh".source = linkConf "${zshRoot}/p10k.zsh";
      home.file.".pi/agent".source = linkConf agentPath;

      # git
      programs.git = {
        enable = true;
        lfs.enable = true;
        settings = {
          user = {
            email = "lakrestofer@gmail.com";
            name = "lakrestofer";
          };
        };
      };

      # notification service
      services.mako = {
        enable = true;
      };
      # Systemwide application themeing
      qt = {
        enable = true;
        platformTheme.name = "gtk";
        style = {
          name = "gtk2";
        };
      };
      gtk = {
        enable = true;
        font.name = "CozetteHiDpi Medium 10";
        theme = {
          name = "Gruvbox-Light";
          package = pkgs-unstable.gruvbox-gtk-theme;
        };
        iconTheme = {
          name = "Gruvbox-Plus-Dark";
          package = pkgs-unstable.gruvbox-plus-icons;
        };
        gtk3.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=0
          '';
        };
        gtk4.extraConfig = {
          Settings = ''
            gtk-application-prefer-dark-theme=0
          '';
        };
      };
    };

}
