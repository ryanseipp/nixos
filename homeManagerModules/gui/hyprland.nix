{
  lib,
  config,
  ...
}: let
  wallpaper = ../../assets/forest-river.jpg;
in {
  options = {hyprland.enable = lib.mkEnableOption "enables hyprland";};

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;

      settings = {
        "$mainMod" = "SUPER";
        "$terminal" = "kitty";
        "$fileManager" = "dolphin";
        "$browser" = "firefox";
        "$menu" = "rofi -show combi";

        monitor = ",highrr,auto,auto,vrr,1";

        exec-once = "waybar";

        input = {
          kb_layout = "us";
          follow_mouse = 1;
          touchpad = {natural_scroll = "false";};

          sensitivity = 0;
        };

        general = {
          gaps_in = 4;
          gaps_out = 16;
          border_size = 1;
          "col.active_border" = "0xee$blueAlpha 0xee$lavenderAlpha 45deg";
          "col.inactive_border" = "0xff$baseAlpha";

          layout = "dwindle";
          allow_tearing = false;
        };

        decoration = {
          rounding = 8;

          blur = {
            enabled = true;
            size = 4;
            passes = 1;

            vibrancy = 0.1696;
          };

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          "col.shadow" = "$base";
        };

        animations = {enabled = false;};

        dwindle = {
          pseudotile = true;
          preserve_split = true;
        };

        # master = {new_status = "master";};

        gestures = {workspace_swipe = false;};

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

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = "${wallpaper}";
        wallpaper = [
          "DP-1,${wallpaper}"
          "DP-2,${wallpaper}"
        ];
        splash = false;
      };
    };

    programs.hyprlock = {
      enable = true;
      settings = {
        general = {
          disable_loading_bar = true;
          grace = 300;
          hide_cursor = true;
          no_fade_in = false;
        };

        background = [
          {
            path = "${wallpaper}";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "'<span foreground=\"##cad3f5\">Password...</span>'";
            shadow_passes = 2;
          }
        ];
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock";
          before_sleep_cmd = "loginctl lock-session";
          after_sleep_cmd = "hyprctl dispatch dpms on";
        };

        listener = [
          {
            timeout = 60; # 900 = 15 min
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 90;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
