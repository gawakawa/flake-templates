_: {
  perSystem = _: {
    treefmt = {
      programs = {
        nixfmt = {
          enable = true;
          includes = [ "*.nix" ];
        };
        oxfmt = {
          enable = true;
          includes = [
            "*.ts"
            "*.tsx"
            "*.js"
            "*.jsx"
            "*.mjs"
            "*.cjs"
            "*.json"
            "*.jsonc"
            "*.json5"
            "*.md"
            "*.mdx"
            "*.yaml"
            "*.yml"
          ];
          excludes = [ "node_modules/*" ];
        };
      };
    };
  };
}
