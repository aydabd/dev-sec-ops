# dev-sec-ops

An independent, profile-neutral developer security baseline for macOS and Linux.

This project uses `mise` to install and execute its pinned toolchain. Users do not need to install
`pre-commit`, `gitleaks`, ShellCheck, or other project tools system-wide. It consumes the reviewed
hook definitions from `pre-commit-hook-registry` but has no dependency on `muximate`.

## Principles

- `mise.toml` and `mise.lock` are the toolchain source of truth.
- The pre-commit template consumes the curated hook registry at one signed, immutable release SHA.
- GitHub Actions uses the same locked tools as local development.
- Git templates are opt-in and versioned; existing Git configuration is never overwritten.
- Existing repositories are configured explicitly and their local pre-commit configuration is never
  replaced automatically.
- Security checks fail closed and never download credentials or scanners during hook execution.
- Upstream updates require immutable pins, a cooling period, review evidence, and passing checks.
- Personal/work account selection belongs to the caller, such as Muximate; this project stays
  profile-neutral.

## Install

Install `mise` using its normal official installation method, then run:

```sh
./scripts/setup.sh
```

This installs the pinned toolchain through `mise` and configures a versioned Git template for new
repositories. Configure an existing repository explicitly:

```sh
./scripts/setup.sh --repo /absolute/path/to/repository
```

The installer does not modify `~/.config/mise/config.toml`, Git identities, SSH configuration,
GitHub credentials, or Muximate profiles.

## Development

```sh
mise install --locked
make check
```

`make check` is read-only. `make lint-fix` is the explicit formatting command. Commit messages are
checked by the mise-managed commitlint command, and all commits must include a `Signed-off-by`
trailer.

## Repository administration

The local GitHub settings, security settings, environments, labels, and ruleset payloads are under
`.github/config`, `.github/environments`, and `.github/rulesets`. They are declarative handoff files;
the repository owner applies them after the initial push.

See [docs/REPOSITORY_SETUP.md](docs/REPOSITORY_SETUP.md) for the exact post-push sequence and
[docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for ownership boundaries.
