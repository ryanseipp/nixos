{
  lib,
  config,
  ...
}:
{
  options = {
    waybar.enable = lib.mkEnableOption "enables waybar";
  };

  config = lib.mkIf config.waybar.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 32;
          margin-bottom = -8;
          mode = "dock";
          modules-left = [
            "custom/nixos-logo"
            "hyprland/workspaces"
            "custom/window-separator"
            "hyprland/window"
          ];
          modules-center = [ ];
          modules-right = [
            "tray"
            "custom/separator"
            "idle_inhibitor"
            "custom/separator"
            "network"
            "custom/separator"
            "cpu"
            "custom/separator"
            "memory"
            "custom/separator"
            "pulseaudio"
            "custom/separator"
            "pulseaudio#source"
            "custom/separator"
            "bluetooth"
            "custom/separator"
            "clock"
          ];
          "custom/nixos-logo" = {
            format = "   ";
            tooltip = false;
          };
          "hyprland/workspaces" = {
            format = "{name}";
          };
          idle_inhibitor = {
            format = "{icon}";
            format-icons = {
              activated = " ";
              deactivated = " ";
            };
          };
          tray = {
            # icon-size = 21;
            spacing = 10;
          };
          clock = {
            format = "{:%a %b %d, %I:%M %p}";
            tooltip-format = ''
              <big>{:%Y %B}</big>
              <tt><small>{calendar}</small></tt>'';
            format-alt = "{:%Y-%m-%d}";
            tooltip = false;
          };
          cpu = {
            format = "  {usage}%";
            tooltip = false;
          };
          memory = {
            format = "  {percentage}%";
          };
          network = {
            family = "ipv6";
            format-wifi = "{essid} ({signalStrength}%) 󰖩 ";
            format-ethernet = "󰈀   {bandwidthUpBits}  {bandwidthDownBits}";
            format-linked = "{ifname} (No IP) 󱚵 ";
            format-disconnected = "Disconnected 󰖪 ";
          };
          bluetooth = {
            format = " 󰂯 ";
            format-disabled = " 󰂲 ";
            on-click = "blueman-manager";
          };
          pulseaudio = {
            scroll-step = 5;
            format = "{icon} {volume}%";
            format-muted = "{icon}";
            format-icons = {
              headphone = "󰋋 ";
              headset = "󰋎 ";
              phone = " ";
              portable = " ";
              car = " ";
              default = [
                " "
                " "
                " "
              ];
              default-muted = "󰝟 ";
            };
            on-click = "pavucontrol";
          };
          clock = {
            interval = 1;
          };
          "pulseaudio#source" = {
            format = "{format_source}";
            format-source = "  ";
            format-source-muted = "  ";
          };
          "custom/separator" = {
            format = " | ";
            tooltip = false;
          };
          "custom/window-separator" = {
            format = " ";
            tooltip = false;
          };
        };
      };

      style = ''
        * {
          border: none;
          font-family: "Iosevka Nerd Font";
          font-weight: bold;
          font-size: 12.5px;
          min-height: 0;
        }

        window#waybar {
          background: alpha(@base, 0.94);
          color: @text;
          border-bottom-width: 1px;
          border-color: @blue;
          border-style: solid;
          border-radius: 0px;
        }

        .modules-left {
          margin-top: 0.125rem;
          margin-bottom: 0.125rem;
          margin-left: 2rem;
        }

        .modules-center {
          margin-top: 0.125rem;
          margin-bottom: 0.125rem;
        }

        .modules-right {
          margin-top: 0.125rem;
          margin-bottom: 0.125rem;
          margin-right: 2rem;
        }

        tooltip {
          background: @base;
          opacity: 0.94;
          box-shadow: 1px 1px 2px @crust;
          border-radius: 4px;
          border-width: 1px;
          border-style: solid;
          border-color: @blue;
          margin: 10px
        }

        tooltip label {
          color: @text;
        }

        #custom-nixos-logo {
          background-image: url('${../../../assets/nix-snowflake-colors.svg}');
          background-size: contain;
          background-position: center;
          background-repeat: no-repeat;
          margin-right: 1rem;
        }

        #workspaces {
          padding: 0 0.5rem;
          background-color: @surface0;
          margin: 0.25rem;
          border-radius: 4px;
          border-width: 1px;
          border-style: solid;
          border-color: @surface1;
        }

        #workspaces button {
          padding: 2px;
          color: @subtext1;
        }

        #workspaces button.active {
          color: @green;
        }

        #workspaces button.focused {
          color: @text;
          border-radius: 4px;
        }

        #workspaces button.urgent {
          color: @overlay0;
          background: @red;
          border-radius: 4px;
        }

        #custom-window-separator {
          margin-left: 1rem;
          margin-right: 0.5rem;
          color: @mauve;
        }

        #window {
          color: @peach;
        }

        #custom-separator {
          padding: 0px 2px 0px 2px;
          color: @surface2;
        }

        #bluetooth {
          margin-left: -4px;
          margin-right: -4px;
          color: @blue;
        }

        #network {
          color: @green;
        }

        #cpu {
          color: @rosewater;
        }

        #memory {
          color: @rosewater;
        }

        #pulseaudio {
          color: @sky;
        }

        #pulseaudio.source {
          color: @sky;
          margin-left: -4px;
          margin-right: -4px;
        }

        #idle_inhibitor.activated {
          color: @maroon;
        }

        #custom-power_btn {
          margin-left: 20px;
          margin-right: 20px;
        }

        #tray > .passive,
        #tray > .active {
          color: #cdd6f4;
        }
      '';
    };
  };
}
