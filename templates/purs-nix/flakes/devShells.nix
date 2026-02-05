_: {
  perSystem =
    {
      config,
      pkgs,
      ps,
      purs-nix,
      ...
    }:
    {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.nodejs
          (ps.command { })
          purs-nix.esbuild
          purs-nix.purescript
        ]
        ++ config.pre-commit.settings.enabledPackages;
        shellHook = ''
          ${config.pre-commit.shellHook}
        '';
      };
    };
}
