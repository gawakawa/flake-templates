{
  inputs = {
    haskellNix.url = "github:input-output-hk/haskell.nix";
    nixpkgs.follows = "haskellNix/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/default";
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      haskellNix,
      treefmt-nix,
      mcp-servers-nix,
      ...
    }:
    let
      supportedSystems = [
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (
      system:
      let
        overlays = [
          haskellNix.overlay
          (final: _: {
            hixProject = final.haskell-nix.hix.project {
              src = ./.;
              evalSystem = "x86_64-linux";
            };
          })
        ];
        pkgs = import nixpkgs {
          inherit system overlays;
          inherit (haskellNix) config;
        };
        flake = pkgs.hixProject.flake { };
        treefmtEval = treefmt-nix.lib.evalModule pkgs {
          programs = {
            cabal-fmt = {
              enable = true;
              includes = [ "*.cabal" ];
            };
            fourmolu = {
              enable = true;
              includes = [ "*.hs" ];
            };
            nixfmt = {
              enable = true;
              includes = [ "*.nix" ];
            };
          };
        };
        mcpConfig = mcp-servers-nix.lib.mkConfig pkgs {
          programs = {
            nixos.enable = true;
          };
        };
      in
      flake
      // {
        legacyPackages = pkgs;

        packages = flake.packages // {
          default = flake.packages."hello:exe:hello";
        };

        devShells = flake.devShells // {
          default = pkgs.mkShell {
            inputsFrom = [ flake.devShells.default ];
            shellHook = ''
              cat ${mcpConfig} > .mcp.json
              echo "Generated .mcp.json"
            '';
          };
        };

        formatter = treefmtEval.config.build.wrapper;

        checks = {
          formatting = treefmtEval.config.build.check self;

          statix =
            pkgs.runCommandLocal "statix"
              {
                src = self;
                nativeBuildInputs = [ pkgs.statix ];
              }
              ''
                statix check $src
                mkdir "$out"
              '';

          deadnix =
            pkgs.runCommandLocal "deadnix"
              {
                src = self;
                nativeBuildInputs = [ pkgs.deadnix ];
              }
              ''
                deadnix --fail $src
                mkdir "$out"
              '';

          actionlint =
            pkgs.runCommandLocal "actionlint"
              {
                src = self;
                nativeBuildInputs = [ pkgs.actionlint ];
              }
              ''
                actionlint $src/.github/workflows/*.yml
                mkdir "$out"
              '';
        };
      }
    );

  nixConfig = {
    extra-substituters = [ "https://cache.iog.io" ];
    extra-trusted-public-keys = [ "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ=" ];
    allow-import-from-derivation = "true";
  };
}
