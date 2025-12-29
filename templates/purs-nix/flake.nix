{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    purs-nix.url = "github:purs-nix/purs-nix";
    ps-tools.follows = "purs-nix/ps-tools";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        {
          config,
          system,
          ...
        }:
        let
          pkgs = import inputs.nixpkgs { inherit system; };

          purs-nix = inputs.purs-nix { inherit system; };

          ps-tools = inputs.ps-tools.legacyPackages.${system};

          ps = purs-nix.purs {
            dependencies = [
              "console"
              "effect"
              "prelude"
            ];

            test-dependencies = [
              "test-unit"
            ];

            dir = ./.;
          };

          mcpConfig = inputs.mcp-servers-nix.lib.mkConfig pkgs {
            programs = {
              nixos.enable = true;
            };
            settings.servers = {
              pursuit = {
                command = "nix";
                args = [
                  "run"
                  "github:gawakawa/pursuit-mcp"
                  "--"
                ];
              };
            };
          };
        in
        {
          packages = with ps; {
            default = app { name = "hello"; };
            bundle = bundle { };
            output = output { };
          };

          apps.default = {
            type = "app";
            program = "${config.packages.default}/bin/hello";
          };

          checks = {
            tests = ps.test.check { };
          };

          devShells.default = pkgs.mkShell {
            buildInputs = [
              pkgs.nodejs
              (ps.command { })
              purs-nix.esbuild
              purs-nix.purescript
              ps-tools.for-0_15.purescript-language-server
            ];
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
              purs-tidy = {
                enable = true;
                package = ps-tools.for-0_15.purs-tidy;
                includes = [ "*.purs" ];
              };
            };
          };
        };
    };
}
