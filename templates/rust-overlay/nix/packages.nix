_: {
  perSystem =
    { pkgs, ... }:
    {
      packages = {
        default = pkgs.rustPlatform.buildRustPackage {
          pname = "";
          version = "0.1.0";

          src = ./..;

          cargoLock = {
            lockFile = ./../Cargo.lock;
          };

          nativeBuildInputs = [ ];

          buildInputs = [ ];

          meta = {
            description = "";
            license = pkgs.lib.licenses.mit;
          };
        };

      };
    };
}
