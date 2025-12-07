{
  description = "A collection of Nix flake templates";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-darwin"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

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
        {
          pkgs,
          system,
          ...
        }:
        let
          mcpConfig = inputs.mcp-servers-nix.lib.mkConfig pkgs {
            programs = {
              fetch.enable = true;
              nixos.enable = true;
            };
          };
        in
        {
          packages = {
            mcp-config = mcpConfig;
          };

          devShells.default = pkgs.mkShell {
            shellHook = ''
              cat ${mcpConfig} > .mcp.json
              echo "Generated .mcp.json"
            '';
          };

          treefmt = {
            programs = {
              nixfmt.enable = true;
            };
          };
        };
    };
}
