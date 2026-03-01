{ ... }:
{
  flake.nixosModules.incusHost =
    { lib, config, ... }:
    {
      options = {
        incusHost.enable = lib.mkEnableOption "enables qemu host tooling";
      };

      config = lib.mkIf config.incusHost.enable {
        virtualisation.incus = {
          enable = true;
        };

        networking.firewall.interfaces.incusbr0 = {
          allowedTCPPorts = [
            53
            67
          ];
          allowedUDPPorts = [
            53
            67
          ];
        };
      };
    };
}
