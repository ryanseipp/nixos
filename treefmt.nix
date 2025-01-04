{ ... }:
{
  projectRootFile = "flake.nix";
  settings.global.excludes = [
    "LICENSE"
    "assets/*"
  ];

  programs = {
    nixfmt.enable = true;
    stylua.enable = true;

    prettier = {
      enable = true;
      settings.proseWrap = "always";
    };
  };
}
