_: {
  perSystem = _: {
    treefmt = {
      programs = {
        gofmt = {
          enable = true;
          includes = [ "*.go" ];
        };
        goimports = {
          enable = true;
          includes = [ "*.go" ];
        };
        nixfmt = {
          enable = true;
          includes = [ "*.nix" ];
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
