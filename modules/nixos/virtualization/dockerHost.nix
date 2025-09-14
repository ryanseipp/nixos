{
  lib,
  config,
  ...
}:
{
  options = {
    dockerHost.enable = lib.mkEnableOption "enables docker";
  };

  config = lib.mkIf config.dockerHost.enable {
    virtualisation.containers.enable = true;
    virtualisation.docker.enable = true;
  };
}
