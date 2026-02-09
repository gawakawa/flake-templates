_: {
  perSystem =
    { my-cli, my-lib, ... }:
    {
      packages = {
        default = my-cli;
        inherit my-cli my-lib;
      };
    };
}
