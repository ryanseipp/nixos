{ ... }:
{
  flake.homeModules.hyprland =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    let
      wallpaper = ../../../assets/dc2.png;
      hyprlandPkg = config.wayland.windowManager.hyprland.package;
      hyprlockPkg = config.programs.hyprlock.package;

      inherit (lib.generators) mkLuaInline;

      # Build `hl.bind("<keys>", <dispatch>[, <opts>])`.
      # `keys` and `dispatch` are raw Lua expressions; `opts` is an optional attrset.
      mkBind = keys: dispatch: opts: {
        _args = [
          (mkLuaInline keys)
          (mkLuaInline dispatch)
        ]
        ++ lib.optional (opts != null) opts;
      };

      modBind = key: dispatch: mkBind ''mainMod .. " + ${key}"'' dispatch null;
      modShiftBind = key: dispatch: mkBind ''mainMod .. " + SHIFT + ${key}"'' dispatch null;
      keyBind = key: dispatch: mkBind ''"${key}"'' dispatch null;
      mouseBind = key: dispatch: mkBind ''mainMod .. " + ${key}"'' dispatch { mouse = true; };

      focusBind = key: dir: modBind key ''hl.dsp.focus({ direction = "${dir}" })'';
      moveBind = key: dir: modShiftBind key ''hl.dsp.window.move({ direction = "${dir}" })'';
      wsFocus = key: n: modBind key "hl.dsp.focus({ workspace = ${toString n} })";
      wsMove = key: n: modShiftBind key "hl.dsp.window.move({ workspace = ${toString n} })";
    in
    {
      options = {
        hyprland.enable = lib.mkEnableOption "enables hyprland";
      };

      config = lib.mkIf config.hyprland.enable {
        wayland.windowManager.hyprland = {
          enable = true;
          configType = "lua";
          xwayland.enable = true;
          systemd = {
            enable = true;
            enableXdgAutostart = true;
          };

          # catppuccin's home-manager module injects
          #   colors._var = mkLuaInline "require('themes.catppuccin')"
          # which renders as `local colors = require('themes.catppuccin')`,
          # giving us colors.blueAlpha / lavenderAlpha / baseAlpha below.
          settings = {
            mainMod._var = "SUPER";
            terminal._var = "ghostty";
            fileManager._var = "dolphin";
            browser._var = "zen-beta";
            menu._var = "rofi -show run";

            monitor = {
              output = "";
              mode = "highrr";
              position = "auto";
              scale = "auto";
              vrr = 1;
            };

            on = {
              _args = [
                "hyprland.start"
                (mkLuaInline ''
                  function()
                    hl.exec_cmd("waybar")
                  end'')
              ];
            };

            config = {
              input = {
                kb_layout = "us";
                follow_mouse = 1;
                touchpad.natural_scroll = false;
                sensitivity = 0;
              };

              general = {
                gaps_in = 4;
                gaps_out = {
                  top = 24;
                  right = 16;
                  bottom = 16;
                  left = 16;
                };
                border_size = 1;
                col = {
                  active_border = mkLuaInline ''{ colors = { "0xee" .. colors.blueAlpha, "0xee" .. colors.lavenderAlpha }, angle = 45 }'';
                  inactive_border = mkLuaInline ''"0xff" .. colors.baseAlpha'';
                };
                layout = "dwindle";
                allow_tearing = false;
              };

              decoration = {
                rounding = 8;
                blur.enabled = true;
                shadow.enabled = true;
              };

              animations.enabled = false;
              dwindle.preserve_split = true;
            };

            workspace_rule = [
              {
                workspace = "1";
                monitor = "DP-1";
                default = true;
              }
              {
                workspace = "2";
                monitor = "DP-2";
                default = true;
              }
              {
                workspace = "3";
                monitor = "DP-1";
              }
              {
                workspace = "4";
                monitor = "DP-2";
              }
              {
                workspace = "5";
                monitor = "DP-1";
              }
              {
                workspace = "6";
                monitor = "DP-2";
              }
              {
                workspace = "7";
                monitor = "DP-1";
              }
              {
                workspace = "8";
                monitor = "DP-2";
              }
              {
                workspace = "9";
                monitor = "DP-1";
              }
              {
                workspace = "10";
                monitor = "DP-2";
              }
            ];

            bind = [
              (modBind "RETURN" "hl.dsp.exec_cmd(terminal)")
              (modBind "Q" "hl.dsp.window.close()")
              (modShiftBind "Q" "hl.dsp.exit()")
              (modBind "F" "hl.dsp.window.fullscreen()")
              (modBind "B" "hl.dsp.exec_cmd(browser)")
              (modBind "V" ''hl.dsp.window.float({ action = "toggle" })'')
              (modBind "R" "hl.dsp.exec_cmd(menu)")
              (modBind "P" ''hl.dsp.exec_cmd([[grim -g "$(slurp -d)" - | wl-copy -t image/png]])'')
              (mkBind ''"ALT + SHIFT + CONTROL + l"'' ''hl.dsp.exec_cmd("loginctl lock-session")'' null)

              (focusBind "h" "left")
              (focusBind "j" "down")
              (focusBind "k" "up")
              (focusBind "l" "right")

              (moveBind "h" "left")
              (moveBind "j" "down")
              (moveBind "k" "up")
              (moveBind "l" "right")

              (wsFocus "1" 1)
              (wsFocus "2" 2)
              (wsFocus "3" 3)
              (wsFocus "4" 4)
              (wsFocus "5" 5)
              (wsFocus "6" 6)
              (wsFocus "7" 7)
              (wsFocus "8" 8)
              (wsFocus "9" 9)
              (wsFocus "0" 10)

              (wsMove "1" 1)
              (wsMove "2" 2)
              (wsMove "3" 3)
              (wsMove "4" 4)
              (wsMove "5" 5)
              (wsMove "6" 6)
              (wsMove "7" 7)
              (wsMove "8" 8)
              (wsMove "9" 9)
              (wsMove "0" 10)

              (keyBind "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%")'')
              (keyBind "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%")'')
              (keyBind "XF86AudioMute" ''hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle")'')
              (keyBind "XF86AudioPlay" ''hl.dsp.exec_cmd("playerctl play-pause")'')
              (keyBind "XF86AudioNext" ''hl.dsp.exec_cmd("playerctl next")'')
              (keyBind "XF86AudioPrev" ''hl.dsp.exec_cmd("playerctl previous")'')

              (mouseBind "mouse:272" "hl.dsp.window.drag()")
              (mouseBind "mouse:273" "hl.dsp.window.resize()")
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
          enable = true;
          settings = {
            general = {
              lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || ${hyprlockPkg}/bin/hyprlock";
              before_sleep_cmd = "loginctl lock-session";
              after_sleep_cmd = "${hyprlandPkg}/bin/hyprctl dispatch dpms on";
            };

            listener = [
              {
                timeout = 600; # 10 minutes - lock screen
                on-timeout = "loginctl lock-session";
              }
              {
                timeout = 900; # 15 minutes - suspend system
                on-timeout = "systemctl suspend";
              }
              # DPMS off removed - causes AMD GPU crashes with hyprlock
            ];
          };
        };
      };
    };
}
