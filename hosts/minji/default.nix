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
  # hardware.amdgpu.opencl.enable = true;

  programs.steam.enable = true;

  programs.adb.enable = true;

  networking.hostName = "minji"; # Define your hostname.
}
