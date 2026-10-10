{ inputs, flake-parts-lib, ... }:
{
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    { lib, ... }:
    {
      options.ciPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Packages for CI environment";
      };
    }
  );

  config.perSystem =
    {
      config,
      pkgs,
      system,
      ...
    }:
    let
      mcpPkgs = import inputs.mcp-servers-nix.inputs.nixpkgs {
        inherit system;
      };
      servers.lean-lsp = {
        command = "${pkgs.lib.getExe' pkgs.uv "uvx"}";
        args = [ "lean-lsp-mcp" ];
      };
      mcpConfig = inputs.mcp-servers-nix.lib.mkConfig mcpPkgs {
        settings.servers = servers;
      };
      codexMcpConfig = inputs.mcp-servers-nix.lib.mkConfig mcpPkgs {
        flavor = "codex";
        format = "toml";
        fileName = "config.toml";
        settings.servers = servers;
      };
    in
    {
      ciPackages = with pkgs; [
        elan
      ];

      packages = {
        ci = pkgs.buildEnv {
          name = "ci";
          paths = config.ciPackages;
        };

        mcp-config = mcpConfig;
        codex-mcp-config = codexMcpConfig;
      };

      _module.args = { inherit mcpConfig codexMcpConfig; };
    };
}
