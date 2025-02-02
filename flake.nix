{
  description = "Configuration file for my nixos systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
    walker = {
      url = "github:abenz1267/walker";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spbased = {
      url = "github:lakrestofer/spbased";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:MarceColl/zen-browser-flake";
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
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      nixosConfigurations = {
        amanda = nixpkgs.lib.nixosSystem {
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
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
        minji = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit pkgs;
            agsbar = self.packages.${system}.agsbar; # we pass the agsbar package output as an input to configuration.org
          };
          modules = [
            ./hosts/minji # desktop
            ./common.nix # base configuration
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-cpu-amd
            nixos-hardware.nixosModules.common-cpu-amd-pstate
            nixos-hardware.nixosModules.common-gpu-amd
            nixos-hardware.nixosModules.common-hidpi
            nixos-hardware.nixosModules.common-pc-ssd
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.fincei = import ./hosts/minji/home.nix;
              home-manager.backupFileExtension = "backup";
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
        selbeiskami = nixpkgs.lib.nixosSystem {
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
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
        nucbox = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit pkgs;
          };
          modules = [ ./hosts/nucbox ];
        };
      };
      packages.${system} = {
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
