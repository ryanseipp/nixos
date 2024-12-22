{
  pkgs,
  inputs,
  ...
}: let
  cloudflareNameservers = ["2606:4700:4700::1111" "2606:4700:4700::1001" "1.1.1.1" "1.0.0.1"];
in {
  imports = [
    ./gc.nix
    ./desktop
    ./server
    ./virtualization
  ];

  nix = {
    package = pkgs.nix;
    nixPath = let
      path = toString ./../..;
    in [
      "nixpkgs=${inputs.nixpkgs}"
      "nixos-config=${path}"
    ];
    channel.enable = false;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  networking = {
    nftables.enable = true;
    firewall.enable = true;
    nameservers = cloudflareNameservers;
    networkmanager.insertNameservers = cloudflareNameservers;
  };

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.zsh.enable = true;
}
