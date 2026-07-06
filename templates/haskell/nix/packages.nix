_: {
  perSystem =
    { hixFlake, ... }:
    {
      packages = hixFlake.packages // {
        default = hixFlake.packages."hello:exe:hello";
      };
    };
}
