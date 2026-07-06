_: {
  perSystem =
    { config, pkgs, ... }:
    let
      pnpm = config.pnpmPackage;
      nodejs = config.nodejsPackage;
      src = ./..;

      pnpmDeps = pkgs.fetchPnpmDeps {
        pname = "pnpm-project-deps";
        version = "1.0.0";
        inherit src pnpm;
        fetcherVersion = 3;
        hash = "sha256-e71+rPRS2Iup6Noa+c9RhJCVkY0LTetMk/tJHNsWjeo=";
      };

      nodeModules = pkgs.stdenvNoCC.mkDerivation {
        name = "pnpm-project-node-modules";
        inherit src pnpmDeps;

        nativeBuildInputs = [
          nodejs
          pkgs.pnpmConfigHook
          pnpm
        ];

        dontBuild = true;

        installPhase = ''
          runHook preInstall
          cp -r node_modules $out
          runHook postInstall
        '';
      };
    in
    {
      # Prebuilt node_modules; consumers symlink this instead of installing.
      packages.nodeModules = nodeModules;

      # `source`-able snippet: writable node_modules, entries symlinked from
      # the store above (no re-download). Needed over a plain `ln -sfn`
      # whenever a consumer also writes new entries under node_modules
      # (e.g. a tool's own cache directory).
      packages.nodeModulesSetup = pkgs.writeShellScript "node-modules-setup" ''
        if [ ! -e node_modules ]; then
          mkdir node_modules
          shopt -s dotglob
          for entry in ${nodeModules}/*; do
            ln -s "$entry" "node_modules/''${entry##*/}"
          done
        fi
      '';
    };
}
