---
name: new-flake
description: Create a template directory, update README.md, CLAUDE.md, flakes/templates.nix, and .github/dependabot.yml, and add .github/CODEOWNERS and .github/workflows/auto-assign.yml for the newly added flake.
user-invocable: true
---

# New Flake Template Documentation

Follow these steps when adding a new flake template:

## 0. Create the template directory

Create `templates/<name>/` with a complete `flake.nix` and any supporting files.

## 1. flakes/templates.nix (template registration)

Add to `flake.templates` in alphabetical order:

```nix
template-name = {
  path = ./templates/template-name;
  description = "Brief description";
};
```

## 2. README.md (user documentation)

Add to `<details>` section in alphabetical order:

```markdown
### template-name

[Description with tools: treefmt (formatters) and mcp-servers-nix (servers).]

\`\`\`bash
nix flake init -t "github:gawakawa/flake-templates#template-name"
\`\`\`
```

## 3. CLAUDE.md (developer documentation)

Add to "Available Templates" section in alphabetical order:

```markdown
- **template-name**: [Language/Tool] development template with treefmt ([formatters]) and mcp-servers-nix ([servers])
```

## 4. .github/dependabot.yml

Add github-actions entry (always required for templates with workflows):

```yaml
  - package-ecosystem: "github-actions"
    directory: "/templates/template-name"
    schedule:
      interval: "weekly"
    cooldown:
      default-days: 7
```

Add language-specific entries if applicable:
- Rust: Add `cargo` entry with semver cooldown settings
- Node.js: Add `npm` entry with semver cooldown settings

## 5. .github/CODEOWNERS

Create with the following content:

```
* @gawakawa
```

## 6. .github/workflows/auto-assign.yml

Requires `BOT_APP_ID` and `BOT_PRIVATE_KEY` secrets to be configured in the repository or organization settings (gawakawa-bot GitHub App).

Create with the following content:

```yaml
name: Auto Assign

on:
  pull_request:

permissions:
  pull-requests: write

jobs:
  auto-assign:
    uses: gawakawa/.github/.github/workflows/auto-assign.yml@main
    secrets:
      BOT_APP_ID: ${{ secrets.BOT_APP_ID }}
      BOT_PRIVATE_KEY: ${{ secrets.BOT_PRIVATE_KEY }}
```
