# Registry and README entry formats

## flakes/templates.nix

Add inside the `flake.templates` attrset in **alphabetical order**:

```nix
template-name = {
  path = ../templates/template-name;
  description = "Brief description";
};
```

Real examples:

```nix
flake-parts = {
  path = ../templates/flake-parts;
  description = "Modular flake with flake-parts";
};
rustup = {
  path = ../templates/rustup;
  description = "Rust template, using rustup";
};
```

## README.md

Add inside the existing `<details>` block in **alphabetical order**:

```markdown
### template-name

One-line description of the template (mention the language/tool and key dependencies).

\`\`\`bash
nix flake init -t "github:gawakawa/flake-templates#template-name"
\`\`\`
```

Real examples:

```markdown
### flake-parts

Modular flake template with flake-parts and treefmt-nix integration.

\`\`\`bash
nix flake init -t "github:gawakawa/flake-templates#flake-parts"
\`\`\`

### rustup

Rust development template with rustup and treefmt (nixfmt + rustfmt).

\`\`\`bash
nix flake init -t "github:gawakawa/flake-templates#rustup"
\`\`\`
```
