{ ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "amanda"; # Define your hostname.

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
