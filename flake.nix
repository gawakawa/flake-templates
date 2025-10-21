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
            path = ./flake-parts;
            description = "Modular flake with flake-parts";
          };
          rust = {
            path = ./rust;
            description = "Rust template, using rustup";
          };
          purs-nix = {
            path = ./purs-nix;
            description = "PureScript template, using purs-nix";
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
