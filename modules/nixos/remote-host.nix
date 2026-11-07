{ ... }:
{
  # Makes the host usable as a headless remote dev box over the tailnet:
  # exit node, Tailscale SSH, mosh, and no sleeping. Flip it off when the
  # machine goes back to being a plain desktop.
  flake.nixosModules.remoteHost =
    { lib, config, ... }:
    let
      cfg = config.remoteHost;
    in
    {
      options.remoteHost = {
        enable = lib.mkEnableOption "remote access over Tailscale (exit node, Tailscale SSH, mosh, no suspend)";
        user = lib.mkOption {
          type = lib.types.str;
          default = "zorbik";
          description = "User whose services should keep running without a seat session.";
        };
      };

      config = lib.mkIf cfg.enable {
        services.tailscale = {
          # "both": IP forwarding + loose rp_filter, required to be an exit node.
          useRoutingFeatures = "both";
          extraSetFlags = [
            "--advertise-exit-node"
            "--ssh"
          ];
        };

        # mosh-server is spawned over Tailscale SSH; only accept its UDP
        # traffic from the tailnet.
        programs.mosh = {
          enable = true;
          openFirewall = false;
        };
        networking.firewall.interfaces.tailscale0.allowedUDPPortRanges = [
          {
            from = 60000;
            to = 61000;
          }
        ];

        # Never sleep: masking the targets also defeats hypridle's
        # `systemctl suspend` and logind's lid/power-key handling.
        systemd.targets = lib.genAttrs [ "sleep" "suspend" "hibernate" "hybrid-sleep" ] (_: {
          enable = false;
        });
        services.logind.settings.Login.IdleAction = lib.mkForce "ignore";

        # Keep user services (ssh-agent etc.) up with nobody at the desk.
        users.users.${cfg.user}.linger = true;
      };
    };
}
