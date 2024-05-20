{
  lib,
  config,
  ...
}: {
  options = {hyprland.enable = lib.mkEnableOption "enables hyprland";};

  config = lib.mkIf config.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd.enable = true;

      settings = {
        "debug:disable_logs" = "false";
        "$rosewaterAlpha" = "f5e0dc";
        "$flamingoAlpha" = "f2cdcd";
        "$pinkAlpha" = "f5c2e7";
        "$mauveAlpha" = "cba6f7";
        "$redAlpha" = "f38ba8";
        "$maroonAlpha" = "eba0ac";
        "$peachAlpha" = "fab387";
        "$yellowAlpha" = "f9e2af";
        "$greenAlpha" = "a6e3a1";
        "$tealAlpha" = "94e2d5";
        "$skyAlpha" = "89dceb";
        "$sapphireAlpha" = "74c7ec";
        "$blueAlpha" = "89b4fa";
        "$lavenderAlpha" = "b4befe";

        "$textAlpha" = "cdd6f4";
        "$subtext1Alpha" = "bac2de";
        "$subtext0Alpha" = "a6adc8";

        "$overlay2Alpha" = "9399b2";
        "$overlay1Alpha" = "7f849c";
        "$overlay0Alpha" = "6c7086";

        "$surface2Alpha" = "585b70";
        "$surface1Alpha" = "45475a";
        "$surface0Alpha" = "313244";

        "$baseAlpha" = "1e1e2e";
        "$mantleAlpha" = "181825";
        "$crustAlpha" = "11111b";

        "$rosewater" = "0xfff5e0dc";
        "$flamingo" = "0xfff2cdcd";
        "$pink" = "0xfff5c2e7";
        "$mauve" = "0xffcba6f7";
        "$red" = "0xfff38ba8";
        "$maroon" = "0xffeba0ac";
        "$peach" = "0xfffab387";
        "$yellow" = "0xfff9e2af";
        "$green" = "0xffa6e3a1";
        "$teal" = "0xff94e2d5";
        "$sky" = "0xff89dceb";
        "$sapphire" = "0xff74c7ec";
        "$blue" = "0xff89b4fa";
        "$lavender" = "0xffb4befe";

        "$text" = "0xffcdd6f4";
        "$subtext1" = "0xffbac2de";
        "$subtext0" = "0xffa6adc8";

        "$overlay2" = "0xff9399b2";
        "$overlay1" = "0xff7f849c";
        "$overlay0" = "0xff6c7086";

        "$surface2" = "0xff585b70";
        "$surface1" = "0xff45475a";
        "$surface0" = "0xff313244";

        "$base" = "0xff1e1e2e";
        "$mantle" = "0xff181825";
        "$crust" = "0xff11111b";

        "$mainMod" = "SUPER";
        "$terminal" = "kitty";
        "$fileManager" = "dolphin";
        "$browser" = "firefox";
        "$menu" = "rofi -show combi";
        env = "XCURSOR_SIZE,24";

        monitor = ",highrr,auto,auto,vrr,1";

        exec-once = "hyprpaper & waybar";

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

        master = {new_is_master = true;};

        gestures = {workspace_swipe = false;};

        # windowrulev2 = "suppressevent maximize, class:.*";

        bind = [
          "$mainMod, RETURN, exec, $terminal"
          "$mainMod, Q, killactive,"
          "$mainMod SHIFT, Q, exit,"
          "$mainMod, F, exec, $fileManager"
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

    programs.hyprlock = {enable = true;};

    services.hyprpaper = {
      enable = true;
      settings = {
        preload = "${../../assets/forest-river.jpg}";
        wallpaper = [
          "DP-1,${../../assets/forest-river.jpg}"
          "DP-2,${../../assets/forest-river.jpg}"
        ];
        splash = false;
      };
    };

    services.hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };

        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };
}
