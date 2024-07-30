{...}: {
  imports = [
    ./gc.nix
    ./desktop
    ./virtualization
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
