{ ... }:
{
  flake.homeModules.mpv =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.mpv;
    in
    {
      options = {
        mpv.enable = lib.mkEnableOption "enables mpv with HDR passthrough on Wayland";
      };

      config = lib.mkIf cfg.enable {
        programs.mpv = {
          enable = true;
          config = {
            # HDR passthrough: mpv converts YUV -> RGB itself and describes the
            # output via wp_color_management_v1, so PQ/HLG sources reach the HDR
            # desktop (Hyprland cm=hdr) intact. Unlike Firefox's HDR overlay this
            # never hands the compositor raw P010 YUV buffers, which Hyprland
            # 0.56 cannot render (see zen-browser.nix).
            vo = "gpu-next";
            gpu-api = "vulkan";
            hwdec = "vaapi";
            target-colorspace-hint = "yes";
            target-colorspace-hint-mode = "source";

            # YouTube via yt-dlp: prefer HDR/10-bit streams up to 4K
            ytdl-format = "bestvideo[height<=2160]+bestaudio/best";
          };
        };

        home.packages = with pkgs; [ yt-dlp ];
      };
    };
}
