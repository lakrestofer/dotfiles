{
  inputs,
  pkgs,
  system,
  ...
}:
{
  nixpkgs.overlays = [
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
        # cargoHash = pkgs.lib.fakeHash;
        cargoHash = "sha256-dcGInrfWftClvzrxYZvrazm+IWWRfOZmxDJPKwu7GwM=";
      };
    })
    (final: prev: {
      terminalist = pkgs.rustPlatform.buildRustPackage {
        name = "terminalist";
        src = builtins.fetchGit {
          url = "https://github.com/romaintb/terminalist";
          ref = "main";
          rev = "fb0ef9adc7d017430a2c6efcb640ec58a6669b1c";
        };
        buildInputs = with pkgs; [ openssl ];
        nativeBuildInputs = [ pkgs.pkg-config ];
        # cargoHash = pkgs.lib.fakeHash;
        cargoHash = "sha256-6dqzzUXchlFJdLGM9W148SEF9XgaT32s06/aFi9XbVk=";
      };
    })
    (final: prev: {
      spotify-player = prev.spotify-player.override {
        withAudioBackend = "pulseaudio";
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

  # hardware.keyboard.qmk.enable = true;
  services.udev.packages = [ pkgs.via ];

  environment.systemPackages =
    (with pkgs; [
      mindustry-wayland
      terminalist
      # python tooling
      uv
      python3
      ruff

      # audio tooling
      pulseaudio
      pulsemixer

      codebook
      bun
      spotify-player
      texliveMedium
      hx-lsp
      p7zip
      unrar
      todoist
      claude-code
      iwe
      strongswan
      nmap
      via
      # qmk
      typos
      typos-lsp
      steel
      inkscape
      postgres-language-server
      pavucontrol
      mpv
      poppler-utils
      vscode-langservers-extracted
      ghostty
      ffmpeg
      libnotify
      fuzzel
      swaybg
      glow
      hledger
      devenv
      yazi
      lazygit
      graphviz
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
      jq
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
      ubuntu-classic
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
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

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.dbus.implementation = "broker";

  services.fwupd.enable = true;
  services.upower.enable = true;
  services.syncthing = {
    enable = true;
    user = "fincei";
    dataDir = "/home/fincei"; # Default folder for new synced folders, instead of /var/lib/syncthing
    configDir = "/home/fincei/.config/syncthing"; # Folder
  };
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder

  system.stateVersion = "24.05"; # Did you read the comment?
}
