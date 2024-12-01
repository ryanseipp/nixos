{
  lib,
  config,
  ...
}: {
  options = {lazygit.enable = lib.mkEnableOption "enables lazygit";};

  config = lib.mkIf config.lazygit.enable {
    programs.lazygit = {
      enable = true;
    };
  };
}
