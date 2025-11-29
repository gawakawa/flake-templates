{ pkgs, ... }:
{
  # name = "project-name";
  compiler-nix-name = "ghc9103"; # Version of GHC to use

  # Tools to include in the development shell
  # shell.tools = {
  #   cabal = "latest";
  #   hlint = "latest";
  #   haskell-language-server = "latest";
  # };
}
