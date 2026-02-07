_: {
  perSystem =
    {
      pkgs,
      config,
      hixFlake,
      ...
    }:
    let
      inputsFrom = [
        hixFlake.devShells.default
        config.treefmt.build.devShell
        config.pre-commit.devShell
      ];
    in
    {
      devShells.default = pkgs.mkShell {
        inherit inputsFrom;
      };
    };
}
