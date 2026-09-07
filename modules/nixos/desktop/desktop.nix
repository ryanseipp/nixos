{ ... }:
{
  flake.nixosModules.desktop =
    {
      lib,
      config,
      pkgs,
      ...
    }:
    {
      options = {
        desktop.enable = lib.mkEnableOption "enables default desktop experience";
      };

      config = lib.mkIf config.desktop.enable {
        catppuccin = {
          enable = true;
          autoEnable = true;
          flavor = "mocha";
        };

        fonts.packages = with pkgs; [
          inter
          iosevka
          nerd-fonts.iosevka
          nerd-fonts.iosevka-term
          nerd-fonts.caskaydia-mono
          nerd-fonts.symbols-only
        ];

        services.displayManager.defaultSession = "hyprland";
        services.displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          package = pkgs.kdePackages.sddm;
        };
        programs.hyprland.enable = true;
        programs.hyprlock.enable = true;

        security.rtkit.enable = true;
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          jack.enable = false;
        };

        services.pulseaudio.extraClientConf = ''
          cookie-file = ~/.config/pulse/cookie
        '';

        services.blueman.enable = true;
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
        };
      };
    };
}
