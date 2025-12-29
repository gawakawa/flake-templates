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
        { pkgs, ... }:
        let
          ciPackages = with pkgs; [
            deno
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

          checks = {
            statix =
              pkgs.runCommandLocal "statix"
                {
                  src = ./.;
                  nativeBuildInputs = [ pkgs.statix ];
                }
                ''
                  cd $src
                  statix check .
                  mkdir "$out"
                '';

            deadnix =
              pkgs.runCommandLocal "deadnix"
                {
                  src = ./.;
                  nativeBuildInputs = [ pkgs.deadnix ];
                }
                ''
                  cd $src
                  deadnix --fail .
                  mkdir "$out"
                '';

            actionlint =
              pkgs.runCommandLocal "actionlint"
                {
                  src = ./.;
                  nativeBuildInputs = [ pkgs.actionlint ];
                }
                ''
                  cd $src
                  actionlint .github/workflows/*.yml
                  mkdir "$out"
                '';

            deno-lint =
              pkgs.runCommandLocal "deno-lint"
                {
                  src = ./.;
                  nativeBuildInputs = [ pkgs.deno ];
                }
                ''
                  cd $src
                  deno task lint
                  mkdir "$out"
                '';

            deno-check =
              pkgs.runCommandLocal "deno-check"
                {
                  src = ./.;
                  nativeBuildInputs = [ pkgs.deno ];
                }
                ''
                  cd $src
                  deno task check
                  mkdir "$out"
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
