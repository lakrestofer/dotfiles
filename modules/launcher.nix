{
  inputs,
  system,
  ...
}:
{

  # programs.walker = {
  #   enable = true;
  # };

  # services.elephant = {
  #   enable = true;
  #   user = "fincei";
  #   group = "fincei";
  #   installService = true;
  # };
  #
  nix.settings = {
    extra-substituters = [
      "https://walker.cachix.org"
      "https://walker-git.cachix.org"
    ];
    extra-trusted-public-keys = [
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
      "walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
    ];
  };

  environment.systemPackages = [
    inputs.walker.packages.${system}.default
    inputs.elephant.packages.${system}.default
  ];

}
