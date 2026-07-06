---
name: new-flake
description: Add a new flake template to this repo. Scaffolds templates/<name>/, registers it in nix/templates.nix, documents it in README.md, wires up .github/dependabot.yml, and copies the standard CODEOWNERS + auto-assign workflow. Use when adding or scaffolding a new flake template.
user-invocable: true
---

# New Flake Template

Copy this checklist and check off each step as you go:

```
- [ ] 1. Create templates/<name>/ with flake.nix
- [ ] 2. Add template docs (CLAUDE.md, CONTRIBUTING.md, docs/DESIGN.md, README.md)
- [ ] 3. Copy standard GitHub files
- [ ] 4. Register in nix/templates.nix
- [ ] 5. Document in root README.md
- [ ] 6. Add dependabot entries
- [ ] 7. Verify
```

## 1. Create `templates/<name>/`

Model the structure on `templates/flake-parts/` (the simplest example):

- `ciPackages` — list of packages for CI
- `devPackages` — extends `ciPackages` with dev-only tools
- `packages.ci` — `pkgs.buildEnv` from `ciPackages`
- `devShells.default` — `pkgs.mkShell` from `devPackages`
- `treefmt` — at minimum `programs.nixfmt.enable = true`

`mcp-servers-nix`/`mkConfig` is optional — only `lean` and `purs-nix` use it.

## 2. Add template docs

Every template carries its own `CLAUDE.md`, `CONTRIBUTING.md`, `docs/DESIGN.md`, and `README.md`. Model these on `templates/flake-parts/` (no extra sections) or `templates/lean/` (keeps an agent-facing `## MCP` note in `CLAUDE.md`).

`CLAUDE.md` — a minimal pointer to the other docs:

```markdown
# CLAUDE.md

- `README.md` — Project overview and usage
- `CONTRIBUTING.md` — Developer guide: commands and workflow
- `docs/DESIGN.md` — Design and architecture
```

If the template needs agent-facing notes (e.g. an MCP server to use, a dependency-update quirk), append them below the pointer as their own `##` section — see `templates/lean/CLAUDE.md` or `templates/pnpm/CLAUDE.md` for real examples. Don't put developer commands here.

`CONTRIBUTING.md` — developer guide with the commands to build/check/test:

```markdown
# Developer Guide

## Commands

- `nix fmt` - Format code
- `nix flake check` - Run checks (format, lint)
- `nix build` - Build the project
```

Add further command lines (test runner, etc.) if the template has one.

`docs/DESIGN.md` — a minimal stub, just the title:

```markdown
# Design
```

`README.md` — an empty stub (leave for future content).

## 3. Copy standard GitHub files

```bash
mkdir -p templates/<name>/.github/workflows
cp .claude/skills/new-flake/assets/CODEOWNERS templates/<name>/.github/CODEOWNERS
cp .claude/skills/new-flake/assets/auto-assign.yml templates/<name>/.github/workflows/auto-assign.yml
cp .claude/skills/new-flake/assets/update-pr-branches.yml templates/<name>/.github/workflows/update-pr-branches.yml
cp .claude/skills/new-flake/assets/update-flake-lock.yml templates/<name>/.github/workflows/update-flake-lock.yml
```

All three workflows (`auto-assign.yml`, `update-pr-branches.yml`, `update-flake-lock.yml`) require `BOT_APP_ID` and `BOT_PRIVATE_KEY` secrets (gawakawa-bot GitHub App) configured at the org or repo level.

When writing `ci.yml`, use `secrets.GITHUB_TOKEN` (not `secrets.GH_TOKEN`) for `install-nix-action`'s `github_access_token` — it's read-only rate-limit avoidance and doesn't need a PAT or App token.

## 4. Register in `nix/templates.nix`

Add the entry in alphabetical order. See [reference/registry-and-readme.md](reference/registry-and-readme.md) for the format and real examples.

## 5. Document in root `README.md`

Add a `### <name>` entry inside the existing `<details>` block, in alphabetical order. See [reference/registry-and-readme.md](reference/registry-and-readme.md) for the format and real examples.

## 6. Add dependabot entries

Add to `.github/dependabot.yml`. The github-actions entry is always required (every template ships auto-assign.yml). Add language entries for Rust/Node.js/Python if applicable. See [reference/dependabot.md](reference/dependabot.md) for formats and real examples.

## 7. Verify

```bash
# New files are invisible to flake eval until staged
git add templates/<name>/

# Test template initialization
tmpdir=$(mktemp -d) && cd "$tmpdir" && nix flake init -t /path/to/repo#<name> && cd -

# Formatting and flake checks
nix fmt
nix flake check
```
