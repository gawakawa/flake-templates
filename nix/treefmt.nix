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
          includes = [ "init-env/**/*.rs" ];
        };
        taplo = {
          enable = true;
          includes = [ "init-env/**/*.toml" ];
        };
      };
    };
  };
}
