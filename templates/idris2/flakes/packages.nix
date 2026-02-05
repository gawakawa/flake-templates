_: {
  perSystem =
    { pkgs, ... }:
    let
      # Define the package using buildIdris (nixpkgs recommended)
      helloPkg = pkgs.idris2Packages.buildIdris {
        ipkgName = "hello";
        src = ./..;
        idrisLibraries = [ ];
      };
    in
    {
      _module.args.helloPkg = helloPkg;

      packages = {
        default = helloPkg.executable;

        ci = pkgs.buildEnv {
          name = "ci";
          paths = [ helloPkg.executable ];
        };
      };
    };
}
