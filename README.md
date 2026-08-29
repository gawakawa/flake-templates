# Flake Templates

A collection of Nix flake templates for various development environments.

## Usage

To initialize a new project with one of these templates:

```bash
nix flake init -t "github:gawakawa/flake-templates#<template-name>"
```

### CLI: init-env

An interactive CLI that creates a GitHub repository and applies one of the
templates above.

```bash
nix run --accept-flake-config "github:gawakawa/flake-templates#init-env"
```

`--accept-flake-config` trusts this flake's `nixConfig`, so `init-env` is
pulled as a prebuilt binary from the `gawakawa` Cachix cache instead of being
compiled — this trusts the `gawakawa` key for any package, not just
`init-env`.

Non-root users usually aren't a
[trusted user](https://nix.dev/manual/nix/latest/command-ref/conf-file#conf-trusted-users),
so the flag has no effect. Add this to your `nix.conf` instead:

```
extra-substituters = https://gawakawa.cachix.org
extra-trusted-public-keys = gawakawa.cachix.org-1:NVSPP7gCC7cr4U7eWhK3MlDGmbU5YkdHqW6+r7oz17c=
```

<details>
<summary>Available Templates</summary>

### flake-parts

Modular flake template with flake-parts and treefmt-nix integration.

```bash
nix flake init -t "github:gawakawa/flake-templates#flake-parts"
```

### rustup

Rust development template with rustup and treefmt (nixfmt + rustfmt + oxfmt).

```bash
nix flake init -t "github:gawakawa/flake-templates#rustup"
```

### rust-overlay

Rust development template with rust-overlay and treefmt (nixfmt + rustfmt + oxfmt + taplo).

```bash
nix flake init -t "github:gawakawa/flake-templates#rust-overlay"
```

### crane

Rust development template with crane and treefmt (nixfmt + rustfmt + oxfmt). Includes comprehensive checks: clippy, doc, fmt, audit, deny, and nextest.

```bash
nix flake init -t "github:gawakawa/flake-templates#crane"
```

### crane-workspace

Rust workspace development template with crane, treefmt (nixfmt + rustfmt + oxfmt), and comprehensive checks. Demonstrates building multiple crates (CLI + library) in a Cargo workspace.

```bash
nix flake init -t "github:gawakawa/flake-templates#crane-workspace"
```

### purs-nix

PureScript development template with purs-nix and treefmt (nixfmt + purs-tidy + oxfmt).

```bash
nix flake init -t "github:gawakawa/flake-templates#purs-nix"
```

### ocaml

OCaml development template with opam-nix and treefmt (nixfmt + oxfmt).

```bash
nix flake init -t "github:gawakawa/flake-templates#ocaml"
```

### python

Python development template with uv and treefmt (nixfmt + ruff + oxfmt + taplo).

```bash
nix flake init -t "github:gawakawa/flake-templates#python"
```

### uv2nix

Python development template with uv2nix for fully Nix-managed Python dependencies and treefmt (nixfmt + ruff + oxfmt + taplo).

```bash
nix flake init -t "github:gawakawa/flake-templates#uv2nix"
```

### deno

Deno development template with treefmt (nixfmt + oxfmt) and oxlint.

```bash
nix flake init -t "github:gawakawa/flake-templates#deno"
```

### pnpm

Node.js development template with pnpm and treefmt (nixfmt + oxfmt).

```bash
nix flake init -t "github:gawakawa/flake-templates#pnpm"
```

### haskell

Haskell development template with haskell.nix and hix.

```bash
nix flake init -t "github:gawakawa/flake-templates#haskell"
```

### go

Go development template with treefmt (nixfmt + gofmt + goimports + golines + oxfmt).

```bash
nix flake init -t "github:gawakawa/flake-templates#go"
```

### lean

Lean theorem prover template with elan, treefmt (nixfmt + oxfmt), and mcp-servers-nix (lean-lsp).

```bash
nix flake init -t "github:gawakawa/flake-templates#lean"
```

### idris2

Idris2 development template with buildIdris and treefmt (nixfmt + oxfmt).

```bash
nix flake init -t "github:gawakawa/flake-templates#idris2"
```

### pack

Idris2 development template with pack (package manager) and treefmt (nixfmt + oxfmt).

```bash
nix flake init -t "github:gawakawa/flake-templates#pack"
```

### terraform

Terraform development template with treefmt (nixfmt + terraform fmt + oxfmt).

```bash
nix flake init -t "github:gawakawa/flake-templates#terraform"
```

</details>

## Development

To add a new template:

1. Create a new directory in the repository (e.g., `my-template/`)
2. Add a `flake.nix` and any other necessary files to that directory
3. Register the template in the root `flake.nix`:

```nix
templates = {
  my-template = {
    path = ./my-template;
    description = "Description of my template";
  };
};
```
