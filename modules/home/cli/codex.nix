{ ... }:
{
  flake.homeModules.codex =
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      cfg = config.codex;
    in
    {
      options.codex.enable = lib.mkEnableOption "enables OpenAI codex";

      config = lib.mkIf cfg.enable {
        programs.codex = {
          enable = true;
          package = pkgs.codex;

          # MCP servers come from the shared `mcp` module.
          enableMcpIntegration = true;

          # OpenRig writes hooks and project trust into config.toml, so merge
          # our settings into a writable file instead of symlinking it.
          mutableSettings = true;
        };
      };
    };
}
