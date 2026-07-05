_: {
  perSystem =
    { pkgs, ... }:
    let
      pnpm = pkgs.pnpm_10;
      nodejs = pkgs.nodejs_24;
      src = ./..;

      pnpmDeps = pkgs.fetchPnpmDeps {
        pname = "pnpm-project-deps";
        version = "1.0.0";
        inherit src pnpm;
        fetcherVersion = 3;
        hash = "sha256-e71+rPRS2Iup6Noa+c9RhJCVkY0LTetMk/tJHNsWjeo=";
      };
    in
    {
      # Prebuilt node_modules; consumers symlink this instead of installing.
      packages.nodeModules = pkgs.stdenvNoCC.mkDerivation {
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
    };
}
