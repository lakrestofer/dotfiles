{ ... }:
{
  services.foundryvtt = {
    enable = true;
    hostName = "minji";
    minifyStaticFiles = true;
    proxyPort = 443;
    proxySSL = true;
    upnp = false;
  };
}
