_: {
  flake = {
    templates = {
      flake-parts = {
        path = ../templates/flake-parts;
        description = "Modular flake with flake-parts";
      };
      rustup = {
        path = ../templates/rustup;
        description = "Rust template, using rustup";
      };
      rust-overlay = {
        path = ../templates/rust-overlay;
        description = "Rust template, using rust-overlay";
      };
      crane = {
        path = ../templates/crane;
        description = "Rust template, using crane";
      };
      purs-nix = {
        path = ../templates/purs-nix;
        description = "PureScript template, using purs-nix";
      };
      python = {
        path = ../templates/python;
        description = "Python template, using uv";
      };
      deno = {
        path = ../templates/deno;
        description = "Deno template";
      };
      pnpm = {
        path = ../templates/pnpm;
        description = "Node.js template, using pnpm";
      };
      haskell = {
        path = ../templates/haskell;
        description = "Haskell template, using haskell.nix and hix";
      };
      go = {
        path = ../templates/go;
        description = "Go template";
      };
      lean = {
        path = ../templates/lean;
        description = "Lean theorem prover template, using elan";
      };
      idris2 = {
        path = ../templates/idris2;
        description = "Idris2 template";
      };
      pack = {
        path = ../templates/pack;
        description = "Idris2 template, using pack";
      };
      terraform = {
        path = ../templates/terraform;
        description = "Terraform template";
      };
    };
  };
}
