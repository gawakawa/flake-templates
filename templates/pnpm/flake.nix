{
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

      perSystem =
        {
          pkgs,
          ...
        }:
        let
          ciPackages = with pkgs; [
            pnpm
            nodejs_24
          ];

          devPackages =
            ciPackages
            ++ (with pkgs; [
              # Additional development tools can be added here
            ]);

          mcpConfig = inputs.mcp-servers-nix.lib.mkConfig pkgs {
            programs = {
              nixos.enable = true;
            };
          };
        in
        {
          packages = {
            ci = pkgs.buildEnv {
              name = "ci";
              paths = ciPackages;
            };

            mcp-config = mcpConfig;
          };

          devShells.default = pkgs.mkShell {
            buildInputs = devPackages;

            shellHook = ''
              cat ${mcpConfig} > .mcp.json
              echo "Generated .mcp.json"
            '';
          };

          treefmt = {
            programs = {
              nixfmt = {
                enable = true;
                includes = [ "*.nix" ];
              };
              statix = {
                enable = true;
                includes = [ "*.nix" ];
              };
              deadnix = {
                enable = true;
                includes = [ "*.nix" ];
              };
              biome = {
                enable = true;
                includes = [
                  "*.ts"
                  "*.tsx"
                  "*.js"
                  "*.jsx"
                ];
              };
              actionlint = {
                enable = true;
                includes = [
                  ".github/workflows/*.yml"
                  ".github/workflows/*.yaml"
                ];
              };
              shellcheck = {
                enable = true;
                includes = [
                  "*.sh"
                  "*.bash"
                  "*.envrc"
                  "*.envrc.*"
                ];
              };
            };
          };
        };
    };
}
