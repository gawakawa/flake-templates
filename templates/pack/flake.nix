{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
      ];

      perSystem =
        {
          config,
          pkgs,
          ...
        }:
        let
          devTools =
            with pkgs;
            [
              idris2Packages.idris2
              idris2Packages.pack
              idris2Packages.idris2Lsp
            ]
            ++ config.pre-commit.settings.enabledPackages;

        in
        {
          packages = {
            ci = pkgs.buildEnv {
              name = "ci";
              paths = devTools;
            };
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
            # Workaround: git-hooks.nix generates `--ignore ""` when ignore = [],
            # causing statix to fail. Override entry to avoid this bug.
            statix = {
              enable = true;
              entry = "${pkgs.statix}/bin/statix check --format errfmt";
            };
            deadnix.enable = true;
            actionlint.enable = true;
            workflow-timeout = {
              enable = true;
              name = "Check workflow timeout-minutes";
              package = pkgs.check-jsonschema;
              entry = "${pkgs.check-jsonschema}/bin/check-jsonschema --builtin-schema github-workflows-require-timeout";
              files = "\\.github/workflows/.*\\.ya?ml$";
            };
          };

          devShells.default = pkgs.mkShell {
            packages = devTools;

            shellHook = ''
              ${config.pre-commit.shellHook}
            '';
          };

          treefmt.programs.nixfmt = {
            enable = true;
            includes = [ "*.nix" ];
          };
        };
    };
}
