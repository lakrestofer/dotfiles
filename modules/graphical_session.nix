{ inputs, pkgs, ... }:
{

  # Niri provides an overlay such that we may build the latest version
  nixpkgs.overlays = [
    inputs.niri.overlays.niri
  ];

  # Our Window  manager of choice
  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    # settings = null;
  };

  # A login service
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember-session";
        user = "fincei";
      };
    };
  };

  environment.systemPackages = with pkgs; [
    # allows us to run x11 applications in niri (which does not implement x11 integration itself)
    xwayland-satellite
  ];

  programs.swaylock.enable = true;
  security.pam.services.swaylock = { };

}
