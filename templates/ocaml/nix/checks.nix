_: {
  perSystem =
    { main, ... }:
    {
      checks.build = main;
    };
}
