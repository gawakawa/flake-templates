{ flake-parts-lib, ... }:
{
  options.perSystem = flake-parts-lib.mkPerSystemOption (
    { lib, ... }:
    {
      options.devTools = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = "Development tools";
      };
    }
  );

  config.perSystem =
    { config, pkgs, ... }:
    {
      devTools = with pkgs; [
        idris2Packages.idris2
        idris2Packages.pack
        idris2Packages.idris2Lsp
      ];

      packages = {
        ci = pkgs.buildEnv {
          name = "ci";
          paths = config.devTools;
        };
      };
    };
}
