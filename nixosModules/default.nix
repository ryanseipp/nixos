{...}: {
  imports = [./gc.nix ./virtualization];

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
