{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {sddm.enable = lib.mkEnableOption "enables sddm";};

  config = lib.mkIf config.sddm.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      catppuccin.enable = true;
      package = pkgs.kdePackages.sddm;
    };
  };
}
