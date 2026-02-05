_: {
  perSystem = _: {
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
}
