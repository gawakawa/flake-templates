{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    let
      craneLib = inputs.crane.mkLib pkgs;
      src = craneLib.cleanCargoSource ../init-env;

      commonArgs = {
        inherit src;
        strictDeps = true;

        buildInputs = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
          pkgs.libiconv
        ];
      };

      cargoArtifacts = craneLib.buildDepsOnly commonArgs;

      initEnv = craneLib.buildPackage (
        commonArgs
        // {
          inherit cargoArtifacts;
        }
      );

      # Injects the self-reference so `nix run .#init-env` targets the
      # current flake's templates, not the published one. A caller-provided
      # INIT_ENV_FLAKE_REF still wins.
      initEnvApp = pkgs.writeShellApplication {
        name = "init-env";
        runtimeInputs = [ initEnv ];
        text = ''
          export INIT_ENV_FLAKE_REF="''${INIT_ENV_FLAKE_REF:-${inputs.self}}"
          exec init-env "$@"
        '';
      };
    in
    {
      packages.init-env = initEnv;

      apps.init-env = {
        type = "app";
        program = "${initEnvApp}/bin/init-env";
      };

      checks = {
        init-env-build = initEnv;

        init-env-clippy = craneLib.cargoClippy (
          commonArgs
          // {
            inherit cargoArtifacts;
            cargoClippyExtraArgs = "--all-targets -- --deny warnings";
          }
        );

        init-env-doc = craneLib.cargoDoc (
          commonArgs
          // {
            inherit cargoArtifacts;
            env.RUSTDOCFLAGS = "--deny warnings";
          }
        );

        init-env-fmt = craneLib.cargoFmt {
          inherit src;
        };

        init-env-toml-fmt = craneLib.taploFmt {
          src = pkgs.lib.sources.sourceFilesBySuffices src [ ".toml" ];
        };

        init-env-audit = craneLib.cargoAudit {
          inherit src;
          inherit (inputs) advisory-db;
        };

        init-env-deny = craneLib.cargoDeny {
          inherit src;
        };
      };
    };
}
