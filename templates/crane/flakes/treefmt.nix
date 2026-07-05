_: {
  perSystem = _: {
    treefmt = {
      programs = {
        nixfmt = {
          enable = true;
          includes = [ "*.nix" ];
        };
        rustfmt = {
          enable = true;
          includes = [ "*.rs" ];
        };
        oxfmt = {
          enable = true;
          includes = [
            "*.json"
            "*.jsonc"
            "*.json5"
            "*.md"
            "*.mdx"
            "*.yaml"
            "*.yml"
          ];
        };
      };
    };
  };
}
