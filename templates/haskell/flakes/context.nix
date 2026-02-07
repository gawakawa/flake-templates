{ inputs, ... }:
{
  perSystem =
    { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          inputs.haskellNix.overlay
          (final: _: {
            hixProject = final.haskell-nix.hix.project {
              src = ./..;
              evalSystem = "x86_64-linux";
            };
          })
        ];
        inherit (inputs.haskellNix) config;
      };
      hixFlake = pkgs.hixProject.flake { };
    in
    {
      _module.args = {
        inherit pkgs hixFlake;
      };
    };
}
