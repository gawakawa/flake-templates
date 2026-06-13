---
name: new-flake
description: Add a new flake template to this repo. Scaffolds templates/<name>/, registers it in flakes/templates.nix, documents it in README.md, wires up .github/dependabot.yml, and copies the standard CODEOWNERS + auto-assign workflow. Use when adding or scaffolding a new flake template.
user-invocable: true
---

# New Flake Template

Copy this checklist and check off each step as you go:

```
- [ ] 1. Create templates/<name>/ with flake.nix
- [ ] 2. Copy standard GitHub files
- [ ] 3. Register in flakes/templates.nix
- [ ] 4. Document in README.md
- [ ] 5. Add dependabot entries
- [ ] 6. Verify
```

## 1. Create `templates/<name>/`

Model the structure on `templates/flake-parts/` (the simplest example):

- `ciPackages` — list of packages for CI
- `devPackages` — extends `ciPackages` with dev-only tools
- `packages.ci` — `pkgs.buildEnv` from `ciPackages`
- `devShells.default` — `pkgs.mkShell` from `devPackages`
- `treefmt` — at minimum `programs.nixfmt.enable = true`

`mcp-servers-nix`/`mkConfig` is optional — only `lean` and `purs-nix` use it.

## 2. Copy standard GitHub files

```bash
mkdir -p templates/<name>/.github/workflows
cp .claude/skills/new-flake/assets/CODEOWNERS templates/<name>/.github/CODEOWNERS
cp .claude/skills/new-flake/assets/auto-assign.yml templates/<name>/.github/workflows/auto-assign.yml
```

The auto-assign workflow requires `BOT_APP_ID` and `BOT_PRIVATE_KEY` secrets (gawakawa-bot GitHub App) configured at the org or repo level.

## 3. Register in `flakes/templates.nix`

Add the entry in alphabetical order. See [reference/registry-and-readme.md](reference/registry-and-readme.md) for the format and real examples.

## 4. Document in `README.md`

Add a `### <name>` entry inside the existing `<details>` block, in alphabetical order. See [reference/registry-and-readme.md](reference/registry-and-readme.md) for the format and real examples.

## 5. Add dependabot entries

Add to `.github/dependabot.yml`. The github-actions entry is always required (every template ships auto-assign.yml). Add language entries for Rust/Node.js/Python if applicable. See [reference/dependabot.md](reference/dependabot.md) for formats and real examples.

## 6. Verify

```bash
# New files are invisible to flake eval until staged
git add templates/<name>/

# Test template initialization
tmpdir=$(mktemp -d) && cd "$tmpdir" && nix flake init -t /path/to/repo#<name> && cd -

# Formatting and flake checks
nix fmt
nix flake check
```
