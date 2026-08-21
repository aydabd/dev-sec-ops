.PHONY: check lint lint-fix format-check config-check markdownlint commitlint shellcheck shfmt actionlint security gitleaks zizmor pre-commit test install clean

check: format-check config-check markdownlint commitlint shellcheck shfmt actionlint security test

lint: pre-commit

lint-fix:
	mise exec --locked -- pre-commit run --all-files

pre-commit:
	mise exec --locked -- pre-commit run --all-files

format-check:
	mise exec --locked -- pre-commit run end-of-file-fixer --all-files
	mise exec --locked -- pre-commit run trailing-whitespace --all-files

config-check:
	mise exec --locked -- pre-commit run check-yaml --all-files
	mise exec --locked -- pre-commit run check-json --all-files
	mise exec --locked -- taplo format --check mise.toml

markdownlint:
	mise exec --locked -- markdownlint --config .markdownlint.yaml '**/*.md'

commitlint:
	printf '%s\n' 'fix: local commitlint verification' | mise exec --locked -- commitlint

shellcheck:
	mise exec --locked -- shellcheck -S error scripts/* config/git/templates/hooks/*

shfmt:
	mise exec --locked -- shfmt -d -i 2 -ci scripts config/git/templates/hooks

actionlint:
	mise exec --locked -- actionlint

security: gitleaks zizmor

gitleaks:
	mise exec --locked -- gitleaks dir --redact --no-banner .

zizmor:
	mise exec --locked -- zizmor --pedantic .github/workflows .github/dependabot.yml .pre-commit-config.yaml

test:
	mise exec --locked -- bats tests

install:
	mise install --locked
	mise exec --locked -- pre-commit install --install-hooks --hook-type pre-commit --hook-type commit-msg

clean:
	rm -rf build dist coverage test-results
