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

Templates are defined in `flakes/templates.nix` and stored under `templates/`. See `README.md` for descriptions of each template.

### Key Integration Points

- **mcp-servers-nix**: Used to generate `.mcp.json` configuration files in development shells using `inputs.mcp-servers-nix.lib.mkConfig`
- **treefmt-nix**: Integrated via `flakeModule` import to provide formatting capabilities through `perSystem.treefmt`
- **flake-parts**: The modular flake framework used both by the repository itself and the flake-parts template

### Template Structure Pattern

Templates follow a consistent pattern:
- `ciPackages` list for CI environment dependencies
- `devPackages` extends `ciPackages` with additional development tools
- `packages.ci` builds an environment from `ciPackages`
- `devShells.default` with development shell configuration
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

Use the `new-flake` skill — it lists every file to create/update (template
`flake.nix`, registry entry in `flakes/templates.nix`, README, CLAUDE.md,
dependabot, CODEOWNERS, auto-assign). After applying the checklist:

1. Test: `nix flake init -t .#<name>` in a temp dir
2. Ensure CI passes: formatting check, build, and flake check
3. When modifying multiple templates, use the Task tool to make edits in parallel
