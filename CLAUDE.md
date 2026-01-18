# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flake templates repository that provides reusable project templates for various development environments. The repository itself uses flake-parts to manage its structure.

## Architecture

The repository has a two-level structure:

1. **Root flake** (`flake.nix`) - Defines the template registry and serves as the distribution mechanism
2. **Template directories** (e.g., `templates/flake-parts/`, `templates/rust/`) - Individual template implementations that users can initialize

Each template is self-contained in its own directory under `templates/` with a complete `flake.nix` and any supporting files. The root flake's `flake.templates` attribute exposes these directories as initializable templates.

### Available Templates

- **flake-parts**: Basic modular flake template with treefmt-nix and mcp-servers-nix integration
- **rustup**: Rust development template using rustup with treefmt (nixfmt + rustfmt) and mcp-servers-nix (serena + nixos)
- **rust-overlay**: Rust development template using rust-overlay with treefmt (nixfmt + rustfmt) and mcp-servers-nix (serena + nixos)
- **crane**: Rust development template using crane with treefmt (nixfmt + rustfmt) and mcp-servers-nix (nixos). Includes comprehensive checks (clippy, doc, fmt, audit, deny, nextest)
- **purs-nix**: PureScript development template using purs-nix with treefmt (nixfmt + purs-tidy) and mcp-servers-nix (nixos + pursuit)
- **python**: Python development template using uv with treefmt (nixfmt + ruff) and mcp-servers-nix (serena + nixos)
- **deno**: Deno development template with treefmt (nixfmt + deno) and mcp-servers-nix (serena + nixos)
- **pnpm**: Node.js development template using pnpm with treefmt (nixfmt + biome) and mcp-servers-nix (serena + nixos)
- **haskell**: Haskell development template using haskell.nix and hix
- **go**: Go development template with treefmt (nixfmt + gofmt + goimports + golines) and mcp-servers-nix (serena + nixos)
- **lean**: Lean theorem prover template using elan with treefmt (nixfmt) and mcp-servers-nix (nixos + lean-lsp)

### Key Integration Points

- **mcp-servers-nix**: Used to generate `.mcp.json` configuration files in development shells using `inputs.mcp-servers-nix.lib.mkConfig`
- **treefmt-nix**: Integrated via `flakeModule` import to provide formatting capabilities through `perSystem.treefmt`
- **flake-parts**: The modular flake framework used both by the repository itself and the flake-parts template

### Template Structure Pattern

Templates follow a consistent pattern:
- `ciPackages` list for CI environment dependencies
- `devPackages` extends `ciPackages` with additional development tools
- `packages.ci` builds an environment from `ciPackages`
- `packages.mcp-config` generates MCP configuration
- `devShells.default` with `shellHook` that auto-generates `.mcp.json`
- `treefmt` configuration for code formatting

## Common Commands

### Formatting
```bash
# Format all Nix files
nix fmt
```

### Building
```bash
# Build default packages
nix build
```

### Testing Templates
```bash
# Check flake validity
nix flake check

# Test template initialization in a temporary directory
mkdir /tmp/test-template && cd /tmp/test-template
nix flake init -t "github:gawakawa/flake-templates#flake-parts"

# If testing immediately after pushing changes, use --refresh to update the cache
nix flake init -t "github:gawakawa/flake-templates#flake-parts" --refresh
```

## Adding New Templates

1. Create a new directory with the template name under `templates/` (e.g., `templates/my-template/`)
2. Add a complete `flake.nix` and any supporting files to that directory
3. Register the template in the root `flake.nix` under `flake.templates`:
   ```nix
   templates = {
     my-template = {
       path = ./templates/my-template;
       description = "Description of my template";
     };
   };
   ```
4. Test the new template with `nix flake init` in a temporary directory
5. Ensure CI passes: formatting check, build, and flake check
