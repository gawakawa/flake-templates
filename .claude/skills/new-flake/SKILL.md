---
name: new-flake
description: Update README.md, CLAUDE.md, flake.nix, and .github/dependabot.yml for the newly added flake.
user-invocable: true
---

# New Flake Template Documentation

Update these 4 files when a new flake template is added:

## 1. flake.nix (template registration)

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
