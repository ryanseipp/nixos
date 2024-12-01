{
  lib,
  pkgs,
  inputs,
  outputs,
  modulesPath,
  ...
}: let
  mkUser = {
    name,
    sshAuthorizedKeyFiles,
    groups ? [],
    ...
  }: {
    "${name}" = {
      isNormalUser = true;
      extraGroups = ["wheel" "incus-admin"] ++ groups;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keyFiles = sshAuthorizedKeyFiles;
    };
  };

  mkHmUser = {name, ...}: {
    "${name}" = {
      imports = [
        outputs.homeManagerModules.default
        inputs.catppuccin.homeManagerModules.catppuccin
      ];

      catppuccin.enable = true;
      catppuccin.flavor = "mocha";

      home.packages = with pkgs; [eza fd neovim];
      home.shellAliases = {
        l = "eza -l";
        la = "eza -la";
      };

      btop.enable = true;
      neovim.enable = false;
      zsh.enableFzf = false;

      home.stateVersion = "24.11";
    };
  };

  userCfgs = [
    {
      name = "virtuser";
      sshAuthorizedKeyFiles = [../../assets/rseipp_id_ed25519.pub];
    }
  ];

  sysUsers = lib.mergeAttrsList (map (u: mkUser u) userCfgs);
  hmUsers = lib.mergeAttrsList (map (u: mkHmUser u) userCfgs);
in {
  imports = [
    "${modulesPath}/virtualisation/incus-virtual-machine.nix"
  ];

  nix.settings.trusted-users = ["root" "@wheel"];

  networking.hostName = "virt-host";

  environment.systemPackages = with pkgs; [
    cilium-cli
    helm
    k9s
    kubectl
    kubernetes
  ];

  # incusHost.enable = true;
  openssh.enable = true;

  users.users =
    sysUsers
    // {
      root.openssh.authorizedKeys.keyFiles = [../../assets/rseipp_id_ed25519.pub];
    };
  home-manager.users = hmUsers;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_6_12;

  system.stateVersion = "24.11";
}
