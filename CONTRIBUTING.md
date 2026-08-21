# Contributing

## Local workflow

```sh
mise install --locked
make check
```

Use Conventional Commit messages, for example `fix: preserve an existing Git template`. Every
commit must include a `Signed-off-by` trailer:

```sh
git commit -s -m "fix: preserve an existing Git template"
```

Changes to `mise.toml`, `mise.lock`, GitHub Actions, Git templates, or security behavior require a
focused review and an explanation of the trust-boundary impact.

## Scope

This repository owns the standalone developer baseline. It does not import code from Muximate or
the pre-commit hook registry at runtime. Integration with either project must use an explicit,
versioned interface.
