_: {
  perSystem =
    {
      config,
      pkgs,
      helloPkg,
      ...
    }:
    let
      devTools =
        with pkgs;
        [
          idris2Packages.idris2Lsp
        ]
        ++ config.pre-commit.settings.enabledPackages;
    in
    {
      devShells.default = pkgs.mkShell {
        # Inherit build environment from the package (recommended pattern)
        inputsFrom = [ helloPkg.executable ];
        packages = devTools;

        shellHook = ''
          ${config.pre-commit.shellHook}
        '';
      };
    };
}
