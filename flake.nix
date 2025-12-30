{
  description = "A collection of Nix flake templates";

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

      flake = {
        templates = {
          flake-parts = {
            path = ./templates/flake-parts;
            description = "Modular flake with flake-parts";
          };
          rustup = {
            path = ./templates/rustup;
            description = "Rust template, using rustup";
          };
          rust-overlay = {
            path = ./templates/rust-overlay;
            description = "Rust template, using rust-overlay";
          };
          purs-nix = {
            path = ./templates/purs-nix;
            description = "PureScript template, using purs-nix";
          };
          python = {
            path = ./templates/python;
            description = "Python template, using uv";
          };
          deno = {
            path = ./templates/deno;
            description = "Deno template";
          };
          pnpm = {
            path = ./templates/pnpm;
            description = "Node.js template, using pnpm";
          };
          haskell = {
            path = ./templates/haskell;
            description = "Haskell template, using haskell.nix and hix";
          };
          go = {
            path = ./templates/go;
            description = "Go template";
          };
          lean = {
            path = ./templates/lean;
            description = "Lean theorem prover template, using elan";
          };
        };
      };

      perSystem =
        { config, pkgs, ... }:
        let
          mcpConfig = inputs.mcp-servers-nix.lib.mkConfig pkgs {
            programs = {
              nixos.enable = true;
            };
          };
        in
        {
          packages = {
            mcp-config = mcpConfig;
          };

          pre-commit.settings.hooks = {
            treefmt.enable = true;
            statix.enable = true;
            deadnix.enable = true;
            actionlint.enable = true;
          };

          devShells.default = pkgs.mkShell {
            shellHook = ''
              ${config.pre-commit.shellHook}
              cat ${mcpConfig} > .mcp.json
              echo "Generated .mcp.json"
            '';
            packages = config.pre-commit.settings.enabledPackages;
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
