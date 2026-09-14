# Notes for agents working on this repo

Read [README.md](README.md) first. It explains the layout, the manifest, the zsh
load order, what wins where, and how committing works. These are the rules
that are easy to break.

## Hard rules
- **The repo is public.** Never write a machine name, internal domain, IP address, employer/client name, username@host, or secret into any file or commit message. Examples use placeholders (`<host>`, `example.com`). Private material goes to the private overlay (`~/code/profile-private`) or to machine-local files (`~/.zshrc.local`, `~/.ssh/config.d/`, `~/.gitconfig`).
- **Never bypass the pre-commit hook** (`--no-verify`, `PROFILE_SKIP_DENYLIST=1`) unless the user explicitly says so for that commit. If it blocks, fix the content.
- **Commits are signed via the 1Password SSH agent** (`export SSH_AUTH_SOCK=~/.1password/agent.sock` where 1Password runs). If signing or ssh fails, ask the user to unlock 1Password. Don't disable signing.
- **Stage files by name,** never `git add -A` / `-u`. Read `git diff --cached --name-status` before every commit.
- **Don't change the live home directory to test.** Use a throwaway `HOME` (README → "Testing a change"). Only run `profile link` on the real home once the fake-HOME run is clean, then verify in a **new** terminal.

## Code constraints
- **`bin/profile` must run under macOS's bash 3.2:** no associative arrays, `mapfile`, `${var,,}`, or `readarray`. It uses `set -euo pipefail`, so inside a loop that feeds a pipe, end with `if …; then …; fi`, not `test && cmd`: a false final test fails the whole pipeline.
- **zsh fragments are sourced at top level** (not inside a function) so oh-my-zsh's `typeset`s stay global. Prefix temporary variables `_profile_` and `unset` them.
- **zsh semantics:** unquoted variables aren't word-split (use `${=var}` when you mean it), `$var:r` is a modifier, and `$p[...]` is a subscript. Brace variables.
- **Guard every tool** in `base` with `(( $+commands[tool] ))`: `base` has to work with only zsh installed.
- **Link files, never directories.** Keep `~/.zprofile` unmanaged.

## Verifying a change
```sh
bash -n bin/profile && sh -n .githooks/pre-commit
for f in zsh/zshrc zsh/zshenv zsh/*/*.zsh zsh/*/*/*.zsh; do zsh -n "$f" || echo "FAIL $f"; done   # one file per zsh -n
T=$(mktemp -d); HOME=$T bin/profile enable dev host && HOME=$T bin/profile check
HOME=$T script -qec "zsh -i -c 'print OK'" /dev/null
gitleaks dir --no-banner --config .gitleaks.toml .
gitleaks dir --no-banner --config ~/code/profile-private/gitleaks/denylist.toml .
```
