_: {
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        package = pkgs.treefmt;
        flakeCheck = true;
        flakeFormatter = true;
        projectRootFile = "flake.nix";
        programs = {
          cabal-fmt = {
            enable = true;
            package = pkgs.haskellPackages.cabal-fmt;
          };
          fourmolu = {
            enable = true;
            package = pkgs.haskellPackages.fourmolu;
          };
          nixfmt = {
            enable = true;
            package = pkgs.nixfmt-rfc-style;
          };
        };
      };
    };
}
