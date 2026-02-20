{
  description = "Configuration file for my nixos systems";
  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    niri.url = "github:sodiboo/niri-flake";
    home-manager.url = "github:nix-community/home-manager";
    helix.url = "github:helix-editor/helix";
    spbased.url = "github:lakrestofer/spbased";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    claude-code.url = "github:sadjow/claude-code-nix";
    sprite-cli.url = "github:jamiebrynes7/sprite-cli-nix";
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        (inputs.import-tree ./modules)
        inputs.home-manager.flakeModules.home-manager
      ];
      systems = [
        "x86_64-linux"
      ];
    };

}
