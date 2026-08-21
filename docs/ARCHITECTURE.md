# Architecture and boundaries

## Independent projects

`dev-sec-ops` is a standalone developer-machine baseline. It owns:

- the pinned `mise` toolchain;
- opt-in Git template installation;
- local pre-commit and security checks;
- update cooling-period reporting; and
- developer guidance for this project.

It does not import or call `muximate` or `pre-commit-hook-registry`. Its hook configuration is an
independent, reviewed copy of the curated upstream hook set. Pin changes require a new review here.

`pre-commit-hook-registry` owns reviewed hook admission and catalog data. `muximate` owns profile
selection and account isolation. A future integration must call a released `dev-sec-ops` command
explicitly; it must not copy policy or create a runtime dependency in either direction.

## Tool execution

`mise.toml` is the only tool-version source. `mise.lock` records resolved artifacts. Local commands
and Git hooks set `MISE_CONFIG_FILE` to this project’s configuration and execute tools with
`mise exec --locked`. The user’s global mise configuration is not overwritten.

## Git template boundary

The installer creates a versioned template directory and configures it only when no conflicting
global `init.templateDir` exists. Git templates affect new repositories. Existing repositories are
configured only through `--repo PATH`; an existing `.pre-commit-config.yaml` is never replaced.

The installed hook invokes the pinned mise-managed `pre-commit` executable and fails closed when a
repository has no local configuration.

## Security boundary

Hooks run without credentials and should not require network access after their environments are
prepared. New scanners are not added to the baseline merely because they are popular: they require
reviewed pinning, platform evidence, performance measurements, and an explicit change to the
baseline contract.
