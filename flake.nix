{
  description = "Configuration file for my nixos systems";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    hyprland = {
      # hyprland stuff
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprpaper = {
      url = "github:hyprwm/hyprlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      # kmonad
      url = "git+https://github.com/kmonad/kmonad?submodules=1&dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      # home manager
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      # some other applications
      url = "github:helix-editor/helix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    astal = {
      url = "github:aylur/astal";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };
  outputs =
    {
      self,
      kmonad,
      home-manager,
      nixpkgs,
      astal,
      ags,
      nixos-hardware,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.amanda = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs;
          agsbar = self.packages.${system}.agsbar; # we pass the agsbar package output as an input to configuration.org
        };
        modules = [
          ./hosts/amanda # thinkpad x220 specific configuration
          ./common.nix # base configuration
          kmonad.nixosModules.default
          nixos-hardware.nixosModules.lenovo-thinkpad-x220
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.fincei = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
      nixosConfigurations.selbeiskami = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs;
          agsbar = self.packages.${system}.agsbar; # we pass the agsbar package output as an input to configuration.org
        };
        modules = [
          ./hosts/selbeiskami # thinkpad x220 specific configuration
          ./common.nix # base configuration
          kmonad.nixosModules.default
          nixos-hardware.nixosModules.lenovo-thinkpad-t14-amd-gen2
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.fincei = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
        ];
      };
      nixosConfigurations.nucbox = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit pkgs;
        };
        modules = [ ./hosts/nucbox ];
      };
      packages.${system} = {
        notes = pkgs.writeShellScriptBin "open_notes" ''
          cd ~/notes
          ${pkgs.zk}/bin/zk edit --interactive
        '';
        agsbar = ags.lib.bundle {
          inherit pkgs;
          src = ./home/ags;
          name = "agsbar";
          entry = "app.ts";

          # additional libraries and executables to add to gjs' runtime
          extraPackages = [
            ags.packages.${system}.hyprland
            ags.packages.${system}.mpris
            ags.packages.${system}.battery
            ags.packages.${system}.wireplumber
            ags.packages.${system}.network
            ags.packages.${system}.tray
          ];
        };
      };
      # === shells ===
      devShells.${system} = {
        default = pkgs.mkShell {
          buildInputs = [
            # includes all Astal libraries
            ags.packages.${system}.agsFull
            # ags.packages.${system}.hyprland
            # ags.packages.${system}.mpris
            # ags.packages.${system}.battery
            # ags.packages.${system}.wireplumber
            # ags.packages.${system}.network
            # ags.packages.${system}.tray

            # includes astal3 astal4 astal-io by default
            (ags.packages.${system}.default.override {
              extraPackages = [
                # cherry pick packages
              ];
            })
          ];
        };
      };
    };
}
