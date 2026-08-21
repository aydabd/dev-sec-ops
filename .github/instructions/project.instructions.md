---
applyTo: "**"
---

# Project instructions

`dev-sec-ops` is a profile-neutral, standalone developer security baseline. Keep tool versions in
`mise.toml` and `mise.lock`; run checks with `mise exec --locked`. Do not introduce account,
profile, or orchestration dependencies. The curated pre-commit hook registry is an explicit,
versioned source for hook definitions. Read `docs/ARCHITECTURE.md` before changing installation,
Git templates, or security behavior. Run `make check` before handoff.
