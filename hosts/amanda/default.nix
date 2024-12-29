{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.useOSProber = false;
  boot.loader.grub.device = "/dev/sda";
  networking.hostName = "amanda"; # Define your hostname.
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  services.kmonad = {
    enable = true;
    keyboards = {

      myKMonadOutput = {
        name = "thinkpadx220";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = builtins.readFile ./home/kmonad/config.kbd;
        defcfg = {
          enable = true;
          fallthrough = true;
          allowCommands = true;
        };
      };
    };
  };
}
