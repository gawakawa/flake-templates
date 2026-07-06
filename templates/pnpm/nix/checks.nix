_: {
  perSystem =
    { config, pkgs, ... }:
    {
      checks.tests = pkgs.stdenvNoCC.mkDerivation {
        name = "tests";
        src = ./..;

        nativeBuildInputs = [
          pkgs.nodejs_24
          pkgs.pnpm_10
        ];

        dontBuild = true;

        doCheck = true;
        checkPhase = ''
          runHook preCheck
          export HOME="$(mktemp -d)" # sandbox's default $HOME isn't writable
          # run from $HOME, not the project dir: pnpm inside a dir with a
          # "packageManager" field tries to fetch/verify that version first
          (cd "$HOME" && pnpm config set manage-package-manager-versions false)
          ln -sfn ${config.packages.nodeModules} node_modules # reuse cached deps
          pnpm test
          runHook postCheck
        '';

        installPhase = ''
          runHook preInstall
          touch $out
          runHook postInstall
        '';
      };
    };
}
