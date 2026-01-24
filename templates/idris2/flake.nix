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
          # Define the package using buildIdris (nixpkgs recommended)
          helloPkg = pkgs.idris2Packages.buildIdris {
            ipkgName = "hello";
            src = ./.;
            idrisLibraries = [ ];
          };

          devTools =
            with pkgs;
            [
              idris2Packages.idris2Lsp
            ]
            ++ config.pre-commit.settings.enabledPackages;

        in
        {
          packages = {
            default = helloPkg.executable;

            ci = pkgs.buildEnv {
              name = "ci";
              paths = [ helloPkg.executable ];
            };
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            actionlint.enable = true;
          };

          devShells.default = pkgs.mkShell {
            # Inherit build environment from the package (recommended pattern)
            inputsFrom = [ helloPkg.executable ];
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
