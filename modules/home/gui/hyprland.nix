{
  lib,
  config,
  pkgs,
  ...
}:
let
  wallpaper = ../../../assets/shop.jpg;
  hyprlandPkg = config.wayland.windowManager.hyprland.package;
  hyprlockPkg = config.programs.hyprlock.package;
in
{
  options = {
    hyprland.enable = lib.mkEnableOption "enables hyprland";
  };

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        enableXdgAutostart = true;
      };

      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "kitty";
        "$fileManager" = "dolphin";
        "$browser" = "brave";
        "$menu" = "rofi -show run";

        monitor = ",highrr,auto,auto,vrr,1";

        exec-once = [
          "hypridle"
          "waybar"
        ];

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad = {
            natural_scroll = "false";
          };

          sensitivity = 0;
        };

        general = {
          gaps_in = 4;
          gaps_out = "24,16,16,16";
          border_size = 1;
          "col.active_border" = "0xee$blueAlpha 0xee$lavenderAlpha 45deg";
          "col.inactive_border" = "0xff$baseAlpha";

          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 8;
          blur.enabled = true;
          shadow.enabled = true;
        };

        animations.enabled = false;

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        gestures = {
          workspace_swipe = false;
        };

        workspace = [
          "1, monitor:DP-1, default:true"
          "2, monitor:DP-2, default:true"
          "3, monitor:DP-1"
          "4, monitor:DP-2"
          "5, monitor:DP-1"
          "6, monitor:DP-2"
          "7, monitor:DP-1"
          "8, monitor:DP-2"
          "9, monitor:DP-1"
          "10, monitor:DP-2"
        ];

        windowrulev2 = [
          "suppressevent maximize, class:.*"
        ];

        bind = [
          "$mainMod, RETURN, exec, $terminal"
          "$mainMod, Q, killactive,"
          "$mainMod SHIFT, Q, exit,"
          "$mainMod, F, fullscreen"
          "$mainMod, B, exec, $browser"
          "$mainMod, V, toggleFloating,"
          "$mainMod, R, exec, $menu"
          ''$mainMod, P, exec, grim -g "$(slurp -d)" - | wl-copy -t image/png''
          "$mainMod, T, toggleSplit,"
          "ALT SHIFT Control, l, exec, loginctl lock-session"

          "$mainMod, h, movefocus, l"
          "$mainMod, j, movefocus, d"
          "$mainMod, k, movefocus, u"
          "$mainMod, l, movefocus, r"

          "$mainMod SHIFT, h, movewindow, l"
          "$mainMod SHIFT, j, movewindow, d"
          "$mainMod SHIFT, k, movewindow, u"
          "$mainMod SHIFT, l, movewindow, r"

          "$mainMod, 1, workspace, 1"
          "$mainMod, 2, workspace, 2"
          "$mainMod, 3, workspace, 3"
          "$mainMod, 4, workspace, 4"
          "$mainMod, 5, workspace, 5"
          "$mainMod, 6, workspace, 6"
          "$mainMod, 7, workspace, 7"
          "$mainMod, 8, workspace, 8"
          "$mainMod, 9, workspace, 9"
          "$mainMod, 0, workspace, 10"

          "$mainMod SHIFT, 1, movetoworkspace, 1"
          "$mainMod SHIFT, 2, movetoworkspace, 2"
          "$mainMod SHIFT, 3, movetoworkspace, 3"
          "$mainMod SHIFT, 4, movetoworkspace, 4"
          "$mainMod SHIFT, 5, movetoworkspace, 5"
          "$mainMod SHIFT, 6, movetoworkspace, 6"
          "$mainMod SHIFT, 7, movetoworkspace, 7"
          "$mainMod SHIFT, 8, movetoworkspace, 8"
          "$mainMod SHIFT, 9, movetoworkspace, 9"
          "$mainMod SHIFT, 0, movetoworkspace, 10"

          ",XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
          ",XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
          ",XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
          ",XF86AudioPlay, exec, playerctl play-pause"
          ",XF86AudioNext, exec, playerctl next"
          ",XF86AudioPrev, exec, playerctl previous"
        ];

        bindm = [
          "$mainMod, mouse:272, movewindow"
          "$mainMod, mouse:273, resizewindow"
        ];
      };
    };

    home.packages = with pkgs; [
      grim
      slurp
      wl-clipboard
    ];

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = "${wallpaper}";
        wallpaper = [
          "DP-1,contain:${wallpaper}"
          "DP-2,contain:${wallpaper}"
        ];
        splash = false;
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 30;
          hide_cursor = true;
        };

        background = {
          monitor = "";
          path = "${wallpaper}";
          blur_passes = 2;
          blur_size = 5;
          color = "$base";
        };

        label = [
          {
            monitor = "";
            text = "$TIME12";
            color = "$text";
            font_size = 90;
            font_family = "$font";
            position = "-30, 0";
            halign = "right";
            valign = "top";
          }
          {
            monitor = "";
            text = ''cmd[update:43200000] date +"%A, %d %B %Y"'';
            color = "$text";
            font_size = 25;
            font_family = "$font";
            position = "-30, -150";
            halign = "right";
            valign = "top";
          }
        ];

        image = {
          monitor = "";
          path = "$HOME/.face";
          size = "100";
          border_color = "$accent";
          position = "0, 75";
          halign = "center";
          valign = "center";
        };

        input-field = {
          monitor = "";
          size = "300, 40";
          outline_thickness = 4;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "$accent";
          inner_color = "$surface0";
          font_color = "$text";
          fade_on_empty = false;
          placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
          hide_input = false;
          check_color = "$accent";
          fail_color = "$red";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          capslock_color = "$yellow";
          position = "0, -47";
          halign = "center";
          valign = "center";
        };
      };
    };

    catppuccin.hyprlock.useDefaultConfig = false;

    services.hypridle = {
      enable = false;
      settings = {
        general = {
          lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${hyprlockPkg}/bin/hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "${hyprlandPkg}/bin/hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 900; # 15 minutes
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 960; # 16 minutes
            on-timeout = "${hyprlandPkg}/bin/hyprctl dispatch dpms off";
            on-resume = "${hyprlandPkg}/bin/hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
