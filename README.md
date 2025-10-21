# Flake Templates

A collection of Nix flake templates for various development environments.

## Usage

To initialize a new project with one of these templates:

```bash
nix flake init -t github:gawakawa/flake-templates#flake-parts
```

## Available Templates

### flake-parts

Modular flake template with flake-parts, treefmt-nix, and mcp-servers-nix integration.

```bash
nix flake init -t "github:gawakawa/flake-templates#flake-parts"
```

### rust

Rust development template with rustup, treefmt (nixfmt + rustfmt), and mcp-servers-nix (serena + nixos).

```bash
nix flake init -t "github:gawakawa/flake-templates#rust"
```

### purs-nix

PureScript development template with purs-nix, treefmt (nixfmt + purs-tidy), and mcp-servers-nix (nixos + pursuit).

```bash
nix flake init -t "github:gawakawa/flake-templates#purs-nix"
```

### python

Python development template with uv, treefmt (nixfmt + ruff), and mcp-servers-nix (serena + nixos).

```bash
nix flake init -t "github:gawakawa/flake-templates#python"
```

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
