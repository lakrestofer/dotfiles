{
  inputs,
  pkgs,
  agsbar,
  ...
}:
let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  system = "x86_64-linux";
in
{
  # hardware
  hardware.graphics = {
    package = pkgs-unstable.mesa.drivers; # use the same mesa drivers as hyprland
    # driSupport32Bit = true;
    # package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };

  # Enable networking
  networking.networkmanager.enable = true;

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
    ];
  };

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
      "https://walker-git.cachix.org"
      "https://walker.cachix.org"
    ];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="

      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
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
    hyprpicker
    inputs.walker.packages.${system}.default
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
    agsbar # from the local argument
    gum
    imv
    wev
    pulsemixer
    upower
    typescript-language-server
    ripgrep
    zathura
    hyprgui
    util-linux
    brightnessctl
    wofi
    swww
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
    TERMINAL = "alacritty";
    STNODEFAULTFOLDER = "true";
    FLAKE = "/home/fincei/dotfiles";
    EDITOR = "hx";
    VISUAL = "hx";
    NIXOS_OZONE_WL = "1";
    BROWSER = "firefox-devedition";
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
