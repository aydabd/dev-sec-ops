# dev-sec-ops agent policy

- Run project tools through `mise exec --locked`.
- Run `make check` before completing work.
- Never bypass hooks with `git commit --no-verify`.
- Never create or expose plaintext credentials, tokens, private keys, or `.env` secrets.
- Do not change GitHub settings, rulesets, environments, or releases unless explicitly requested.
- Treat tool and Action updates as supply-chain reviews with immutable pins and evidence.
- This project is profile-neutral; do not add personal/work account logic here.
