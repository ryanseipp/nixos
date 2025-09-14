{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    docker.enable = lib.mkEnableOption "enables docker";
  };

  config = lib.mkIf config.docker.enable {
    home.packages = with pkgs; [
      dive
      docker
      docker-compose
    ];
    home.shellAliases = {
      d = "docker";
      dc = "d compose";
      dcu = "dc up -d --build --remove-orphans";
      dcs = "dc stop";
      dcd = "dc down";
    };
  };
}
