{pkgs, ...}: {
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    kubectl
    cowsay
  ];

  system.stateVersion = "24.05";
}
