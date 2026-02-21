{ self, ... }:
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
        self.homeModules.themeModule
        self.homeModules.fuzzelModule
        self.homeModules.makoModule
        self.homeModules.yaziModule
        self.homeModules.statusBarModule
      ];
      # user packages (only installed per user)
      home.packages = [ ];
      xdg.configFile = mergeAttrsList (linkConfFiles [
        "helix"
        "sioyek"
        "codebook"
        "ghostty"
        "zathura"
        "niri"
        "scripts"
        "lazygit"
        # "yazi"
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
    };

}
