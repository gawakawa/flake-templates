_: {
  perSystem =
    {
      config,
      pkgs,
      mcpConfig,
      codexMcpConfig,
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
          mkdir -p .codex
          cat ${codexMcpConfig} > .codex/config.toml
          echo "Generated .codex/config.toml"
        '';
      };
    };
}
