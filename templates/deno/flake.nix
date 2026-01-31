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
          ciPackages = with pkgs; [
            deno
          ];

          devPackages =
            ciPackages
            ++ config.pre-commit.settings.enabledPackages
            ++ (with pkgs; [
              # Additional development tools can be added here
            ]);

        in
        {
          packages = {
            ci = pkgs.buildEnv {
              name = "ci";
              paths = ciPackages;
            };
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            actionlint.enable = true;
            denolint.enable = true;
            workflow-timeout = {
              enable = true;
              name = "Check workflow timeout-minutes";
              package = pkgs.check-jsonschema;
              entry = "${pkgs.check-jsonschema}/bin/check-jsonschema --builtin-schema github-workflows-require-timeout";
              files = "\\.github/workflows/.*\\.ya?ml$";
            };
          };

          devShells.default = pkgs.mkShell {
            buildInputs = devPackages;

            shellHook = ''
              ${config.pre-commit.shellHook}
            '';
          };

          treefmt = {
            programs = {
              nixfmt = {
                enable = true;
                includes = [ "*.nix" ];
              };
              deno = {
                enable = true;
                includes = [
                  "*.ts"
                  "*.tsx"
                  "*.js"
                  "*.jsx"
                  "*.json"
                  "*.md"
                ];
                excludes = [ "node_modules/*" ];
              };
            };
            settings.formatter.deno.options = [
              "--config"
              "deno.json"
            ];
          };
        };
    };
}
