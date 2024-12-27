{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.grub.device = "/dev/nvme0n1";
  networking.hostName = "selbeiskami"; # Define your hostname.

  services.kmonad = {
    enable = true;
    keyboards = {

      myKMonadOutput = {
        name = "thinkpadt14";
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
