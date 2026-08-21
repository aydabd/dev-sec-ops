# Repository setup handoff

Apply these settings after pushing the initial commits. This repository intentionally stores the
desired state locally but does not mutate GitHub administration automatically.

## Recommended order

1. Push `main` and verify the CI, CodeQL, and commit-policy workflows.
2. Enable vulnerability alerts, dependency graph, automated security fixes, secret scanning, push
   protection, and private vulnerability reporting where available.
3. Apply `.github/config/repo-settings.json`.
4. Create the labels in `.github/config/labels-default.json`.
5. Apply `.github/rulesets/branch-main.json` and `.github/rulesets/tags-semver.json`.
6. Create the development and production environments from `.github/environments/` only when the
   release workflow is enabled; configure reviewers in GitHub rather than committing credentials.
7. Verify that required status-check names exactly match the workflow job names.

Do not enable a ruleset requiring a check before its workflow has produced that check at least once.
Keep a maintainer bypass available only for repository recovery and record its use.
