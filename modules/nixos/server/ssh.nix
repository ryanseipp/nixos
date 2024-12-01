{
  lib,
  config,
  ...
}: {
  options = {openssh.enable = lib.mkEnableOption "enables ssh access";};

  config = lib.mkIf config.openssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
      allowSFTP = false;
    };

    programs.ssh.startAgent = true;
    security.pam.sshAgentAuth.enable = true;

    services.fail2ban = {
      enable = true;
    };

    environment.enableAllTerminfo = true;
  };
}
