{ pkgs, ... }:
{

  networking.networkmanager = {
    enable = true;
    plugins = with pkgs; [
      networkmanager-l2tp
      networkmanager-strongswan
    ];
  };

  services.strongswan = {
    enable = true;
  };
  networking.firewall.enable = false;
  programs.nm-applet.enable = true;

  environment.etc."strongswan.conf" = {
    text = '''';
  };

}
