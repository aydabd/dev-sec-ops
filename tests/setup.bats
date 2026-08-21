#!/usr/bin/env bats

setup() {
    PROJECT_ROOT="${BATS_TEST_DIRNAME}/.."
}

@test "setup reports its version without changing state" {
    run "${PROJECT_ROOT}/scripts/setup.sh" --version
    [ "$status" -eq 0 ]
    [ "$output" = "0.1.0" ]
}

@test "baseline shell scripts have valid syntax" {
    run bash -n "${PROJECT_ROOT}/scripts/setup.sh" "${PROJECT_ROOT}/scripts/security-cooldown-sync.sh" \
        "${PROJECT_ROOT}/config/git/templates/hooks/pre-commit" \
        "${PROJECT_ROOT}/config/git/templates/hooks/commit-msg"
    [ "$status" -eq 0 ]
}

@test "template hooks contain no unresolved root placeholder" {
    run grep -R __DEV_SEC_OPS_ROOT__ "${PROJECT_ROOT}/config/git/templates/hooks"
    [ "$status" -eq 0 ]
}
