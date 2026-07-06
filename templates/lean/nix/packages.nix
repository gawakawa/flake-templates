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
      mcpConfig =
        inputs.mcp-servers-nix.lib.mkConfig
          (import inputs.mcp-servers-nix.inputs.nixpkgs {
            inherit system;
          })
          {
            settings.servers = {
              lean-lsp = {
                command = "${pkgs.lib.getExe' pkgs.uv "uvx"}";
                args = [ "lean-lsp-mcp" ];
              };
            };
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
      };

      _module.args.mcpConfig = mcpConfig;
    };
}
