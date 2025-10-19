# Flake Templates

A collection of Nix flake templates for various development environments.

## Usage

To initialize a new project with one of these templates:

```bash
nix flake init -t github:gawakawa/flake-templates#flake-parts
```

## Available Templates

### flake-parts

Modular Nix flake template using flake-parts with the following features:

- **flake-parts**: Modular flake configuration system
- **treefmt-nix**: Automatic code formatting with nixfmt
- **mcp-servers-nix**: MCP (Model Context Protocol) server configuration
- Multi-system support (x86_64-linux, aarch64-darwin)
- Separate CI and development package sets
- Automatic `.mcp.json` generation in development shell

```bash
nix flake init -t "github:gawakawa/flake-templates#flake-parts"
```

#### Features

The template includes:

- `packages.ci`: CI environment package bundle
- `packages.mcp-config`: MCP server configuration
- `devShells.default`: Development shell with MCP config auto-generation
- `treefmt`: Code formatting with nixfmt enabled

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
