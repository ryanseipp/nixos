{
  lib,
  config,
  ...
}: {
  options = {incusHost.enable = lib.mkEnableOption "enables qemu host tooling";};

  config = lib.mkIf config.incusHost.enable {
    virtualisation.incus = {
      enable = true;
      # preseed = {
      #   networks = [
      #     {
      #       config = {
      #         "ipv4.address" = "auto";
      #         "ipv6.address" = "auto";
      #       };
      #     }
      #   ];
      #   profiles = [
      #     {
      #       name = "default";
      #       devices = {
      #         eth0 = {
      #           name = "eth0";
      #           network = "incusbr0";
      #           type = "nic";
      #         };
      #         root = {
      #           path = "/";
      #           pool = "default";
      #           type = "disk";
      #         };
      #       };
      #     }
      #   ];
      #   storage_pools = [
      #     {
      #       name = "default";
      #       config = {
      #         source = "/var/lib/incus/storage_pools/default";
      #       };
      #       driver = "dir";
      #     }
      #   ];
      # };
    };

    networking.firewall.interfaces.incusbr0 = {
      allowedTCPPorts = [53 67];
      allowedUDPPorts = [53 67];
    };
  };
}
