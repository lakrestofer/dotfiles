{ pkgs, ... }:
{

  programs.java.enable = true;
  programs.steam = {
    enable = true;
    # wineTricks.enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.uinput.enable = true;

}
