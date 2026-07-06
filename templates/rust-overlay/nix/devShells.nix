_: {
  perSystem =
    { config, pkgs, ... }:
    {
      devShells.default =
        with pkgs;
        mkShell {
          buildInputs = [
            rust-bin.stable.latest.default
          ]
          ++ config.pre-commit.settings.enabledPackages;

          shellHook = ''
            ${config.pre-commit.shellHook}
          '';
        };
    };
}
