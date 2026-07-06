_: {
  perSystem = _: {
    treefmt = {
      programs = {
        terraform = {
          enable = true;
          includes = [
            "*.tf"
            "*.tfvars"
          ];
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
