_: {
  perSystem =
    { my-cli, ... }:
    {
      apps.default = {
        type = "app";
        program = "${my-cli}/bin/my-cli";
      };
    };
}
