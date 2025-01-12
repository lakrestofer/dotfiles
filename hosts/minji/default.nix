{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.systemd-boot = {
    enable = true;
    consoleMode = "max";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "minji"; # Define your hostname.
}
