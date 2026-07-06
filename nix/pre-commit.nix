_: {
  perSystem =
    { pkgs, ... }:
    {
      pre-commit.settings.hooks = {
        treefmt.enable = true;
        # Workaround: git-hooks.nix generates `--ignore ""` when ignore = [],
        # causing statix to fail. Override entry to avoid this bug.
        statix = {
          enable = true;
          entry = "${pkgs.statix}/bin/statix check --format errfmt";
        };
        deadnix.enable = true;
        actionlint.enable = true;
        zizmor = {
          enable = true;
          args = [ "--offline" ];
        };
        workflow-timeout = {
          enable = true;
          name = "Check workflow timeout-minutes";
          package = pkgs.check-jsonschema;
          entry = "${pkgs.check-jsonschema}/bin/check-jsonschema --builtin-schema github-workflows-require-timeout";
          files = "^\\.github/workflows/.*\\.ya?ml$";
        };
      };
    };
}
