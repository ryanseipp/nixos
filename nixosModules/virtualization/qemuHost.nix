{
  lib,
  config,
  ...
}: {
  options = {qemuHost.enable = lib.mkEnableOption "enables qemu host tooling";};

  config = lib.mkIf config.qemuHost.enable {
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
  };
}
