# Security policy

## Reporting

Do not open a public issue for a suspected vulnerability. Use GitHub private vulnerability
reporting for this repository when enabled, or contact the repository owner privately.

## Security properties

- Tool versions and GitHub Actions are pinned immutably.
- The installer is opt-in and preserves existing user configuration.
- Hooks do not require credentials or network access during normal execution.
- Secrets must never be committed, including in examples or test fixtures unless the fixture is
  unmistakably synthetic and excluded from secret output.
- Security fixes may bypass the normal release cooling period only with documented evidence.
