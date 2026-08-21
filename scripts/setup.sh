#!/usr/bin/env bash
set -euo pipefail

BASELINE_VERSION="0.1.0"
SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BASELINE_ROOT="$(CDPATH= cd -- "${SCRIPT_DIR}/.." && pwd)"
TEMPLATE_SOURCE="${BASELINE_ROOT}/config/git/templates"
TEMPLATE_DIR="${HOME}/.config/git/templates/dev-sec-ops-${BASELINE_VERSION}"
REPOS=()

usage() {
  cat <<'EOF'
Usage: setup.sh [--repo PATH] [--template-dir PATH]

Install the pinned mise toolchain and an opt-in Git template. Existing global
Git templates and repository-local pre-commit configurations are preserved.
EOF
}

die() {
  echo "[ERROR] $*" >&2
  exit 1
}

escape_sed_replacement() {
  local value=$1
  value=${value//\\/\\\\}
  value=${value//&/\\&}
  value=${value//|/\\|}
  printf '%s' "$value"
}

while (($#)); do
  case "$1" in
    --repo)
      (($# >= 2)) || die "--repo requires a path"
      REPOS+=("$2")
      shift 2
      ;;
    --template-dir)
      (($# >= 2)) || die "--template-dir requires a path"
      TEMPLATE_DIR="$2"
      shift 2
      ;;
    --version)
      echo "$BASELINE_VERSION"
      exit 0
      ;;
    --help | -h)
      usage
      exit 0
      ;;
    *) die "unknown option: $1" ;;
  esac
done

command -v git >/dev/null 2>&1 || die "git is required"
command -v mise >/dev/null 2>&1 || die "mise is required; install mise and rerun setup.sh"

CURRENT_TEMPLATE="$(git config --global --get init.templateDir || true)"
if [[ -n "$CURRENT_TEMPLATE" && "$CURRENT_TEMPLATE" != "$TEMPLATE_DIR" ]]; then
  die "global init.templateDir is already set to '$CURRENT_TEMPLATE'; use --template-dir with that directory or change it manually"
fi

(cd "$BASELINE_ROOT" && mise install --locked)
escaped_root=$(escape_sed_replacement "$BASELINE_ROOT")
mkdir -p "$TEMPLATE_DIR/hooks"
for hook in pre-commit commit-msg; do
  sed "s|__DEV_SEC_OPS_ROOT__|$escaped_root|g" \
    "$TEMPLATE_SOURCE/hooks/$hook" >"$TEMPLATE_DIR/hooks/$hook"
  chmod 0755 "$TEMPLATE_DIR/hooks/$hook"
done
cp "$TEMPLATE_SOURCE/.pre-commit-config.yaml" "$TEMPLATE_DIR/.pre-commit-config.yaml"

if [[ -z "$CURRENT_TEMPLATE" ]]; then
  git config --global init.templateDir "$TEMPLATE_DIR"
fi

for repo in "${REPOS[@]}"; do
  [[ -d "$repo" ]] || die "repository path does not exist: $repo"
  git -C "$repo" rev-parse --show-toplevel >/dev/null 2>&1 || die "not a Git repository: $repo"
  repo_root=$(git -C "$repo" rev-parse --show-toplevel)
  config="$repo_root/.pre-commit-config.yaml"
  if [[ ! -e "$config" ]]; then
    cp "$TEMPLATE_SOURCE/.pre-commit-config.yaml" "$config"
    echo "[+] Installed baseline configuration in $repo_root"
  else
    echo "[i] Preserving existing configuration in $repo_root"
    if ! grep -Eq '^[[:space:]]*- id: gitleaks[[:space:]]*$' "$config"; then
      echo "[WARNING] $repo_root does not declare gitleaks; local policy was preserved." >&2
    fi
  fi
  (cd "$repo_root" && MISE_CONFIG_FILE="$BASELINE_ROOT/mise.toml" mise exec --locked -- pre-commit install --install-hooks)
done

echo "[SUCCESS] dev-sec-ops $BASELINE_VERSION installed through mise."
[[ ${#REPOS[@]} -gt 0 ]] || echo "Pass --repo PATH for each existing repository you want to configure."
