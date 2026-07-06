_: {
  perSystem =
    {
      config,
      pkgs,
      mcpConfig,
      ...
    }:
    let
      devPackages =
        config.ciPackages
        ++ config.pre-commit.settings.enabledPackages
        ++ (with pkgs; [
          uv
          ripgrep
        ]);
    in
    {
      devShells.default = pkgs.mkShell {
        buildInputs = devPackages;

        shellHook = ''
          ${config.pre-commit.shellHook}
          cat ${mcpConfig} > .mcp.json
          echo "Generated .mcp.json"
        '';
      };
    };
}
