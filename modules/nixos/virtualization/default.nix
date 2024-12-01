{lib, ...}: {
  imports = [./podmanHost.nix ./incusHost.nix];

  options = {virtualization.enable = lib.mkEnableOption "enables virtualization hosts";};
}
