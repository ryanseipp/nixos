{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    podman.enable = lib.mkEnableOption "enables podman";
  };

  config = lib.mkIf config.podman.enable {
    home.packages = with pkgs; [
      dive
      podman-tui
      podman-compose
    ];
    home.shellAliases = {
      docker = "podman";
      p = "podman";
      pc = "p compose";
      pcu = "pc up -d --build --remove-orphans";
      pcs = "pc stop";
      pcd = "pc down";
    };
  };
}
