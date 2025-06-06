{
  inputs,
  pkgs,
  system,
  ...
}:
{
  # hardware
  # as of 24.11
  hardware.graphics = {
    package = pkgs.mesa;
    enable = true;
    enable32Bit = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # enable zsh as shell
  programs.zsh = {
    enable = true;
  };
  programs.nix-ld.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users.fincei = {
    isNormalUser = true;
    description = "fincei";
    extraGroups = [
      "docker"
      "networkmanager"
      "wheel"
      "input"
      "uinput"
      "kvm"
      "adbusers"
    ];
  };
  nix.settings.trusted-users = [
    "fincei"
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    substituters = [
      "https://hyprland.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };
  programs.direnv = {
    enable = true;
    package = pkgs.direnv;
    silent = false;
    loadInNixShell = true;
    direnvrcExtra = "";
    enableZshIntegration = true;
    nix-direnv = {
      enable = true;
      package = pkgs.nix-direnv;
    };
  };
  virtualisation.docker.enable = true;
  environment.localBinInPath = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    devenv
    lsp-ai
    yazi
    lazygit
    graphviz
    supabase-cli
    awscli
    deno
    hunspellDicts.sv_SE
    hunspellDicts.en_US
    hunspell
    sqlite
    clang-tools
    clang
    clangStdenv
    aseprite
    calibre
    waybar
    tofi
    inputs.spbased.packages.${system}.default
    inputs.spbased.packages.${system}.flashcard
    inputs.spbased.packages.${system}.reading
    git-filter-repo
    vscode
    hyprpicker
    nodejs
    slurp
    grim
    pdfgrep
    texlive.combined.scheme-full
    pandoc
    imagemagick_light
    dprint
    wget
    fzf
    zk
    jo
    jq
    taskwarrior-tui
    taskwarrior3
    zed-editor
    syncthing
    taplo
    nixfmt-rfc-style
    nil
    nvd
    nix-output-monitor
    nh
    nautilus
    mako
    anki-bin
    gum
    imv
    wev
    pulsemixer
    upower
    typescript-language-server
    ripgrep
    zathura
    util-linux
    brightnessctl
    wofi
    eza
    zoxide
    wl-clipboard
    inputs.helix.packages.${system}.default
    hyprpolkitagent
    git
    # tmux
    gnumake
    zellij
    alacritty
    brave
    firefox-devedition-bin
    btop
    fastfetch
    eza
    tree
    zip
    unzip
    pciutils
    usbutils
  ];

  fonts = {
    packages = with pkgs; [
      nerd-fonts.gohufont
      nerd-fonts.hack
      ubuntu_font_family
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      cozette
    ];
    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        serif = [ "Liberation Serif" ];
        sansSerif = [ "Ubuntu" ];
        monospace = [ "Ubuntu Mono" ];
      };
    };
  };

  # environment variables
  environment.sessionVariables = {
    SPBASED_ROOT = "/home/fincei/vault";
    ZK_NOTEBOOK_DIR = "/home/fincei/vault/notes";
    TERMINAL = "alacritty";
    STNODEFAULTFOLDER = "true";
    FLAKE = "/home/fincei/dotfiles";
    EDITOR = "hx";
    VISUAL = "hx";
    NIXOS_OZONE_WL = "1";
    BROWSER = "brave";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland,x11";
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };
  # programs.hyprlock = {
  #   enable = true;
  #   package = pkgs.hyprlock;
  #   # package = inputs.hyprlock.packages.${pkgs.stdenv.hostPlatform.system}.hyprlock;
  # };
  programs.uwsm = {
    enable = true;
    waylandCompositors = {
      hyprland = {
        prettyName = "Hyprland";
        comment = "Hyprland compositor managed by UWSM";
        binPath = "/run/current-system/sw/bin/Hyprland";
      };
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.pipewire = {
    enable = true;
  };
  services.dbus.implementation = "broker";
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet";
        user = "fincei";
      };
    };
  };
  services.fwupd.enable = true;
  services.upower.enable = true;
  services.syncthing = {
    enable = true;
    user = "fincei";
    dataDir = "/home/fincei"; # Default folder for new synced folders, instead of /var/lib/syncthing
    configDir = "/home/fincei/.config/syncthing"; # Folder
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

  security.pam.services.hyprlock = { };

  system.stateVersion = "24.05"; # Did you read the comment?
}
