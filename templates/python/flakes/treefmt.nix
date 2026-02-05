_: {
  perSystem = _: {
    treefmt = {
      programs = {
        nixfmt = {
          enable = true;
          includes = [ "*.nix" ];
        };
        ruff-format = {
          enable = true;
          includes = [ "*.py" ];
        };
      };
    };
  };
}
