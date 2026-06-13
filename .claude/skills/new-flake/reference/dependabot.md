# dependabot.yml entry formats

All entries go in `.github/dependabot.yml` under `updates:`.

## github-actions (always required)

Every template ships `.github/workflows/auto-assign.yml`, so always add this entry.
Note the path ends in `/.github/workflows`, not just the template directory.

```yaml
- package-ecosystem: "github-actions"
  directory: "/templates/template-name/.github/workflows"
  schedule:
    interval: "weekly"
  cooldown:
    default-days: 7
```

Real example (flake-parts):

```yaml
- package-ecosystem: "github-actions"
  directory: "/templates/flake-parts/.github/workflows"
  schedule:
    interval: "weekly"
  cooldown:
    default-days: 7
```

## Language entries (add when applicable)

Language entries use `directory: "/templates/template-name"` (no `/.github/workflows`)
and a longer cooldown with semver granularity.

### Rust (cargo)

```yaml
- package-ecosystem: "cargo"
  directory: "/templates/template-name"
  schedule:
    interval: "weekly"
  cooldown:
    default-days: 7
    semver-major-days: 30
    semver-minor-days: 7
    semver-patch-days: 3
```

Real example (rust-overlay):

```yaml
- package-ecosystem: "cargo"
  directory: "/templates/rust-overlay"
  schedule:
    interval: "weekly"
  cooldown:
    default-days: 7
    semver-major-days: 30
    semver-minor-days: 7
    semver-patch-days: 3
```

### Node.js (npm — used by pnpm template)

```yaml
- package-ecosystem: "npm"
  directory: "/templates/template-name"
  schedule:
    interval: "weekly"
  cooldown:
    default-days: 7
    semver-major-days: 30
    semver-minor-days: 7
    semver-patch-days: 3
```

### Python (pip — used by uv2nix template)

```yaml
- package-ecosystem: "pip"
  directory: "/templates/template-name"
  schedule:
    interval: "weekly"
  cooldown:
    default-days: 7
    semver-major-days: 30
    semver-minor-days: 7
    semver-patch-days: 3
```
