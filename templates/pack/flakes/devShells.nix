_: {
  perSystem =
    { config, pkgs, ... }:
    let
      devPackages = config.devTools ++ config.pre-commit.settings.enabledPackages;
    in
    {
      devShells.default = pkgs.mkShell {
        packages = devPackages;

        shellHook = ''
          ${config.pre-commit.shellHook}
        '';
      };
    };
}
