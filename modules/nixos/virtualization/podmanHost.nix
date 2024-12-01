{
  lib,
  config,
  ...
}: {
  options = {podmanHost.enable = lib.mkEnableOption "enables podman";};

  config = lib.mkIf config.podmanHost.enable {
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
