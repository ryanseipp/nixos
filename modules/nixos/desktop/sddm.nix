{
  lib,
  config,
  pkgs,
  ...
}:
{
  options = {
    sddm.enable = lib.mkEnableOption "enables sddm";
  };

  config = lib.mkIf config.sddm.enable {
    services.displayManager.defaultSession = "hyprland";
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      package = pkgs.kdePackages.sddm;
    };
    programs.hyprland.enable = true;
    programs.hyprlock.enable = true;
  };
}
