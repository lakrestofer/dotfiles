{ inputs, config, pkgs, ... }: let
  pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};
in {
  imports = [
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = false;

  # hardware
  hardware.graphics = {
    package = pkgs-unstable.mesa.drivers;
    # driSupport32Bit = true;
    # package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;   
  };
  swapDevices = [{
    device = "/swapfile";
    size = 16 * 1024; # 16GB
  }];
  
  networking.hostName = "machina"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # enable zsh as shell
  programs.zsh = { enable = true; };
  users.defaultUserShell = pkgs.zsh;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.fincei = {
    isNormalUser = true;
    description = "fincei";
    extraGroups = [ "networkmanager" "wheel" "input" "uinput"];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
    ];
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    nvd
    nix-output-monitor
    nh
    nautilus
    mako
    # anki-bin
    inputs.agsbar.packages.${pkgs.system}.default
    imv
    nwg-look
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
    hyprpaper
    inputs.hyprpaper.packages.${pkgs.stdenv.hostPlatform.system}.default
    eza
    zoxide
    wl-clipboard
    inputs.helix.packages.${pkgs.system}.default
    hyprpolkitagent
    git
    # tmux
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
    FLAKE = "/home/fincei/dotfiles";
    EDITOR = "hx";
    VISUAL = "hx";
    NIXOS_OZONE_WL = "1";
    BROWSER = "firefox-devedition";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
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
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    withUWSM  = true;
  };
  services.hypridle = {
    enable = true;
    package = pkgs.hypridle;
    # package = inputs.hypridle.packages.${pkgs.stdenv.hostPlatform.system}.hypridle;
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

  security.pam.services.hyprlock = {}; 

services.kmonad = {
 enable = true;
   keyboards = {
     
     myKMonadOutput = {
       name = "thinkpadx220";
       device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
       config = builtins.readFile ./home/kmonad/config.kbd;
       defcfg = {
         enable = true;
         fallthrough = true;
         allowCommands = true;
       };
     };
   };
};


  system.stateVersion = "24.05"; # Did you read the comment?

}
