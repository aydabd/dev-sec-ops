---
applyTo: "**"
---

# Project instructions

`dev-sec-ops` is a profile-neutral, standalone developer security baseline. Keep tool versions in
`mise.toml` and `mise.lock`; run checks with `mise exec --locked`. Do not introduce dependencies on
Muximate or the pre-commit hook registry. Read `docs/ARCHITECTURE.md` before changing installation,
Git templates, or security behavior. Run `make check` before handoff.
