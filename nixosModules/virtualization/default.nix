{
  lib,
  config,
  ...
}: {
  imports = [./podmanHost.nix ./qemuHost.nix];

  options = {virtualization.enable = lib.mkEnableOption "enables default desktop experience";};

  config = lib.mkIf config.virtualization.enable {
    podmanHost.enable = true;
    qemuHost.enable = true;
  };
}
