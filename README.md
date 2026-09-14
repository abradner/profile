# profile

Alex's shell and tool configuration. It's kept in git and **symlinked** into
place, so editing a live dotfile edits the repo.

## Install

```sh
git clone https://github.com/abradner/profile.git ~/code/profile
~/code/profile/install.sh --dry-run   # show what would change
~/code/profile/install.sh             # link base config
```

Re-running is safe: links that are already right are left alone. Any real file
in the way is moved to `~/.local/state/profile/backup/<timestamp>/` first and
never overwritten. Works on macOS (stock bash 3.2) and Debian.

## Use cases

Everything is tagged with a use case. `base` always applies. The rest are
switched on per machine, by hand:

| use case  | what it adds |
|-----------|--------------|
| `base`    | zsh core (history, safe aliases, functions, starship/fzf/mise when installed), git config + signing, ssh config skeleton. No dependencies: it also works on a bare box with no oh-my-zsh or starship. |
| `dev`     | oh-my-zsh dev plugins, single-letter aliases, rails helpers |
| `host`    | byobu config, for machines that hold long-running sessions |
| `desktop` | alacritty, 1Password commit signing on Linux |

```sh
profile enable dev host     # link, and remember the choice on this machine
profile disable host
profile status              # use cases, overlays, the state of every link
profile check               # exit 1 on drift, for provisioning/doctor scripts
```

The choices are stored in `~/.config/profile/`, not in the repo.

## Layout

- `links`: the manifest. Each line is `<usecase> <os> <source> <target>`, where `<os>` is `all`, `darwin` or `linux`.
- `bin/profile`: the linker, linked to `~/.local/bin/profile`.
- `zsh/zshrc`: the only zsh file that gets linked. It sources `zsh/<usecase>/*.zsh` and `zsh/<usecase>/<os>/*.zsh` for every enabled use case, sorted by filename across all of them. The numbering is described at the top of the file.
- `git/config`: linked as `~/.config/git/config`. `~/.gitconfig` stays machine-local and overrides it.
- `ssh/config`: holds no hosts. It includes `~/.ssh/config.d/*.conf`.

Machine-only shell settings go in `~/.zshrc.local`.

## Overlays

Host lists, internal names and anything else that can't be public live in a
private overlay repo with the same `links` + `zsh/<usecase>/` layout:

```sh
profile overlay add ~/code/profile-private
```

Work machines keep their overlay as a local-only directory.

## Secret scanning

`install.sh` points `core.hooksPath` at `.githooks/`. The pre-commit hook runs
[gitleaks](https://github.com/gitleaks/gitleaks) twice over the staged changes:

1. `.gitleaks.toml`: gitleaks' default rules plus private IP literals, 1Password references and credential assignments.
2. The overlay's `gitleaks/denylist.toml`: names that must never appear here. The list lives in the overlay because it would be a leak itself.

The hook refuses to commit if gitleaks is missing. It also refuses when no
overlay is registered, unless you set `PROFILE_SKIP_DENYLIST=1` for that commit.
