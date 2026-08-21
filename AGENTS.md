# Agent instructions

Read [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) before changing installation, tool pins, Git
templates, workflows, or repository settings. Read [CONTRIBUTING.md](CONTRIBUTING.md) before
committing.

## Rules

- Keep `mise.toml` and `mise.lock` authoritative for the toolchain.
- Never install project tools through Homebrew, npm, pip, or ad-hoc downloads when a mise tool is
  available.
- Never expose credentials, modify GitHub settings, or publish releases unless explicitly requested.
- Treat upstream updates as supply-chain reviews; do not make routine floating-version updates.
- Run `make check` before handing off changes. If a required platform tool is unavailable, run every
  available check and report the exact limitation.
- Use signed commits with a `Signed-off-by` trailer.
