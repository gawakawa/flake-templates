# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a Nix flake templates repository that provides reusable project templates for various development environments. The repository itself uses flake-parts to manage its structure.

## Architecture

The repository has a two-level structure:

1. **Root flake** (`flake.nix`) - Defines the template registry and serves as the distribution mechanism
2. **Template directories** (e.g., `flake-parts/`) - Individual template implementations that users can initialize

Each template is self-contained in its own directory with a complete `flake.nix` and any supporting files. The root flake's `flake.templates` attribute exposes these directories as initializable templates.

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

# Check formatting (CI mode)
nix fmt -- --ci
```

### Building
```bash
# Build default packages
nix build

# Build specific package
nix build .#mcp-config
nix build .#ci
```

### Development
```bash
# Enter development shell (auto-generates .mcp.json)
nix develop
```

### Testing Templates
```bash
# Check flake validity
nix flake check

# Test template initialization in a temporary directory
mkdir /tmp/test-template && cd /tmp/test-template
nix flake init -t github:gawakawa/flake-templates#flake-parts
```

## Adding New Templates

1. Create a new directory with the template name (e.g., `my-template/`)
2. Add a complete `flake.nix` and any supporting files to that directory
3. Register the template in the root `flake.nix` under `flake.templates`:
   ```nix
   templates = {
     my-template = {
       path = ./my-template;
       description = "Description of my template";
     };
   };
   ```
4. Test the new template with `nix flake init` in a temporary directory
5. Ensure CI passes: formatting check, build, and flake check
