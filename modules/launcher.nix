{ inputs, pkgs, ... }:
{

  programs.walker = {
    enable = true;
  };

  services.elephant = {
    enable = true;
    user = "fincei";
    group = "fincei";
  };

}
