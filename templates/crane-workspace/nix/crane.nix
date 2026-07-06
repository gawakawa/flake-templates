{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      craneLib = inputs.crane.mkLib pkgs;
      src = craneLib.cleanCargoSource ./..;

      # Common arguments can be set here to avoid repeating them later
      commonArgs = {
        inherit src;
        strictDeps = true;

        buildInputs =
          # [
          #   # Add additional build inputs here
          # ]
          # ++
          pkgs.lib.optionals pkgs.stdenv.isDarwin [
            # Additional darwin specific inputs can be set here
            pkgs.libiconv
          ];

        # Additional environment variables can be set directly
        # MY_CUSTOM_VAR = "some value";
      };

      # Build *just* the cargo dependencies (for the entire workspace),
      # so we can reuse all of that work (e.g. via cachix) when running in CI
      cargoArtifacts = craneLib.buildDepsOnly commonArgs;

      individualCrateArgs = commonArgs // {
        inherit cargoArtifacts;
        inherit (craneLib.crateNameFromCargoToml { inherit src; }) version;
        # NB: we disable tests since we'll run them all via cargo-nextest
        doCheck = false;
      };

      fileSetForCrate =
        crate:
        pkgs.lib.fileset.toSource {
          root = ./..;
          fileset = pkgs.lib.fileset.unions [
            ./../Cargo.toml
            ./../Cargo.lock
            (craneLib.fileset.commonCargoSources ./../crates/my-lib)
            (craneLib.fileset.commonCargoSources crate)
          ];
        };

      # Build individual workspace members
      my-cli = craneLib.buildPackage (
        individualCrateArgs
        // {
          pname = "my-cli";
          cargoExtraArgs = "-p my-cli";
          src = fileSetForCrate ./../crates/my-cli;
        }
      );

      my-lib = craneLib.buildPackage (
        individualCrateArgs
        // {
          pname = "my-lib";
          cargoExtraArgs = "-p my-lib";
          src = fileSetForCrate ./../crates/my-lib;
        }
      );
    in
    {
      _module.args = {
        inherit
          craneLib
          src
          commonArgs
          cargoArtifacts
          my-cli
          my-lib
          ;
      };
    };
}
