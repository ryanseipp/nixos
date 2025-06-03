{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.brave;
in
{
  options = {
    brave.enable = lib.mkEnableOption "enables the brave browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      brave
    ];
  };
}
