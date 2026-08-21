#!/usr/bin/env bash
set -euo pipefail

COOLDOWN_DAYS=14
CUTOFF_DATE=$(date -d "${COOLDOWN_DAYS} days ago" +%s 2>/dev/null || date -v-${COOLDOWN_DAYS}d +%s)

echo "Auditing releases older than ${COOLDOWN_DAYS} days."

check_release() {
  local repo=$1
  local response published release_epoch
  response=$(gh api "repos/${repo}/releases/latest") || {
    echo "[ERROR] Could not read ${repo}" >&2
    return 1
  }
  published=$(printf '%s' "$response" | mise exec --locked -- python -c 'import json,sys; print(json.load(sys.stdin).get("published_at", ""))')
  [[ -n "$published" ]] || {
    echo "[ERROR] ${repo} has no published release" >&2
    return 1
  }
  release_epoch=$(mise exec --locked -- python -c 'import datetime,sys; print(int(datetime.datetime.fromisoformat(sys.argv[1].replace("Z", "+00:00")).timestamp()))' "$published")
  if ((release_epoch < CUTOFF_DATE)); then
    echo "[PASS] ${repo} latest release is outside the cooling period."
  else
    echo "[WAIT] ${repo} latest release is inside the cooling period."
  fi
}

check_release gitleaks/gitleaks
check_release pre-commit/pre-commit
check_release astral-sh/ruff
echo "Report only: update pins through a reviewed change; this script never edits mise.toml or mise.lock."
