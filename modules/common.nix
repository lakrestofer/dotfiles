{
  inputs,
  pkgs,
  system,
  ...
}:
{
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    (final: prev: {
      # lsp for custom snippets and code actions
      hx-lsp = pkgs.rustPlatform.buildRustPackage {
        name = "hx-lsp";
        src = builtins.fetchGit {
          url = "https://github.com/erasin/hx-lsp";
          ref = "main";
          rev = "b86dc789a473d941cb42e533e58a0bf247159395";
        };
        buildInputs = [ ];
        nativeBuildInputs = [ pkgs.pkg-config ];
        cargoHash = "sha256-dcGInrfWftClvzrxYZvrazm+IWWRfOZmxDJPKwu7GwM=";
      };
    })
  ];

  hardware.graphics = {
    package = pkgs.mesa;
    enable = true;
    enable32Bit = true;
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-l2tp
      networkmanager-strongswan
    ];
  };
  services.strongswan = {
    enable = true;
  };
  networking.firewall.enable = false;
  programs.nm-applet.enable = true;

  environment.etc."strongswan.conf" = {
    text = '''';
  };

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

  programs.thunderbird.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users.fincei = {
    isNormalUser = true;
    description = "fincei";
    extraGroups = [
      "ydotool"
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
    ];
    trusted-public-keys = [
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

  programs.ydotool.enable = true;

  virtualisation.docker.enable = true;
  environment.localBinInPath = true;

  hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.via ];
  environment.systemPackages =
    (with pkgs; [
      texliveMedium
      hx-lsp
      p7zip
      unrar
      todoist
      pulseaudio
      uv
      claude-code
      iwe
      strongswan
      nmap
      via
      qmk
      racket
      typos
      typos-lsp
      steel
      inkscape
      postgres-lsp
      nufmt
      nushell
      pavucontrol
      mpv
      poppler-utils
      vscode-langservers-extracted
      ghostty
      warp-terminal
      chafa
      ffmpeg
      qutebrowser
      xwayland-satellite
      libnotify
      fuzzel
      (python3.withPackages (
        ps: with ps; [
          pip
          pygame
        ]
      ))
      swaybg
      glow
      hledger
      devenv
      lsp-ai
      yazi
      lazygit
      graphviz
      supabase-cli
      awscli
      hunspellDicts.sv_SE
      hunspellDicts.en_US
      hunspell
      sqlite
      clang-tools
      clang
      clangStdenv
      calibre
      waybar
      inputs.spbased.packages.${system}.default
      git-filter-repo
      vscode
      hyprpicker
      nodejs
      slurp
      grim
      pdfgrep
      # texlive.combined.scheme-full
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
      firefox-devedition
      btop
      fastfetch
      eza
      tree
      zip
      unzip
      pciutils
      usbutils
    ])
    ++ [

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
    STEEL_LSP_HOME = "/home/fincei/.config/steel-lsp";
    SPBASED_ROOT = "/home/fincei/vault";
    ZK_NOTEBOOK_DIR = "/home/fincei/vault/notes";
    TERMINAL = "ghostty";
    STNODEFAULTFOLDER = "true";
    NH_FLAKE = "/home/fincei/dotfiles";
    LEDGER_FILE = "/home/fincei/vault/finances/2025.journal";
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

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    # settings = null;
  };

  # List services that you want to enable:
  services.emacs = {
    enable = true;
    package = pkgs.emacs-pgtk;
    startWithGraphical = true;
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    wireplumber = {
      extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };
      };
    };
  };
  services.dbus.implementation = "broker";
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember-session";
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
