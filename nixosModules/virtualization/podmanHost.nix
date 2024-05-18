{
  lib,
  config,
  ...
}: {
  options = {podmanHost.enable = lib.mkEnableOption "enables podman";};

  config = lib.mkIf config.qemuHost.enable {
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
