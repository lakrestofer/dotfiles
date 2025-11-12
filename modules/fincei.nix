{ ... }:
{
  users.users.fincei = {
    isNormalUser = true;
    description = "fincei";
    extraGroups = [
      "ydotool"
      "docker"
      "networkmanager"
      "wheel"
      "input"
      "uinput"
      "kvm"
      "adbusers"
    ];
  };
  nix.settings.trusted-users = [
    "fincei"
  ];
}
