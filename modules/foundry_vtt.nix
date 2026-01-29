{ inputs, pkgs, ... }:
{
  services.foundryvtt = {
    enable = true;
    hostName = "minji";
    minifyStaticFiles = true;
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
    # dataDir = "/home/fincei/applications/foundry-vtt/foundry-data";
    package = inputs.foundryvtt.packages.x86_64-linux.foundryvtt_13.overrideAttrs {
      version = "13.0.0+351";
    };
  };
}
