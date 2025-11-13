{ pkgs, ... }:
{

  programs.steam = {
    enable = true;
    protontricks.enable = true;
  };

  hardware.graphics = {
    package = pkgs.mesa;
    enable = true;
    enable32Bit = true;
  };
}
