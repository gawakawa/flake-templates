{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
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
          system,
          ...
        }:
        let
          ciPackages = with pkgs; [
            idris2
            idris2Packages.idris2Lsp
            idris2Packages.pack
          ];

          devPackages = ciPackages ++ config.pre-commit.settings.enabledPackages;

          mcpConfig = inputs.mcp-servers-nix.lib.mkConfig (import inputs.mcp-servers-nix.inputs.nixpkgs {
            inherit system;
          }) { programs.nixos.enable = true; };
        in
        {
          packages = {
            ci = pkgs.buildEnv {
              name = "ci";
              paths = ciPackages;
            };

            mcp-config = mcpConfig;
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            actionlint.enable = true;
          };

          devShells.default = pkgs.mkShell {
            buildInputs = devPackages;

            shellHook = ''
              ${config.pre-commit.shellHook}
              cat ${mcpConfig} > .mcp.json
              echo "Generated .mcp.json"

              # Enable global package management
              export IDRIS2_PREFIX="$HOME/.idris2"
              export IDRIS2_PACKAGE_PATH="''${IDRIS2_PACKAGE_PATH:+$IDRIS2_PACKAGE_PATH:}$HOME/.idris2"
            '';
          };

          treefmt = {
            programs = {
              nixfmt = {
                enable = true;
                includes = [ "*.nix" ];
              };
            };
          };
        };
    };
}
