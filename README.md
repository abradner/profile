# profile

Alex's shell and tool configuration (zsh, starship, git, ssh, byobu,
alacritty). It's kept in git and **symlinked** into place, so editing a live
dotfile edits this repo. Works on macOS and Debian/Ubuntu, from a bare server
with only zsh up to a full desktop.

> **This repo is public.** Nothing in it may name a machine, internal domain,
> IP address, employer or client, and it must never hold a secret. Those go in
> the private overlay (see [Overlays](#overlays)). A pre-commit hook enforces
> this, so read [Committing](#committing) before your first change.

## Start here

| You want to… | Go to |
|---|---|
| Set up a new or existing machine | [docs/bootstrap.md](docs/bootstrap.md), a step-by-step playbook with a check after every step |
| Keep machines in step, change things, retire a machine | [Lifecycle](#lifecycle) |
| See what's linked on this machine | `profile status` |
| Change a dotfile | Edit it in place (it's a symlink) or in this repo, then [commit](#committing) |
| Add a new dotfile or zsh fragment | [Changing things](#changing-things) |
| Work on this repo as an agent | [AGENTS.md](AGENTS.md) as well as this file |

Quickest possible start on a machine that already has git and zsh. Clone anywhere **outside a synced folder** (Nextcloud, iCloud and the like); `~/.local/src/profile` works where `~/code` is synced:
```sh
git clone https://github.com/abradner/profile.git ~/code/profile
~/code/profile/install.sh --dry-run    # shows what would change
~/code/profile/install.sh              # links base
```

## Use cases

Every link is tagged with a use case. `base` always applies. The others are
switched on per machine, deliberately by hand:

| use case  | what it adds | typical machine |
|-----------|--------------|-----------------|
| `base`    | zsh core (history, safe aliases, functions, editor, starship/fzf/mise when installed), git identity + SSH signing, ssh config skeleton. **No dependencies**: without oh-my-zsh or starship it falls back to plain completion and a simple prompt. | every machine, including servers and appliances |
| `dev`     | oh-my-zsh dev plugins, single-letter aliases (`k`, `g`, `d`, `lg`…; `qc` lists them), rails helpers, `dsh`, `highlight` | where you write code |
| `host`    | byobu config (F12 prefix, so C-a/C-q reach Claude Code) | machines holding long-running sessions |
| `desktop` | alacritty, 1Password commit signing on Linux | a local GUI with 1Password (Linux) |

## Commands

`profile` is linked to `~/.local/bin/profile` (before the first link, use
`~/code/profile/bin/profile`):

```sh
profile link [--dry-run]   # create/repair links for base + enabled use cases (install.sh = this)
profile update             # git pull --ff-only this repo + overlays, then link
profile check              # exit 1 on drift; for provisioning / doctor scripts
profile status             # use cases, overlays, the state of every link
profile enable dev host    # enable use cases on this machine, then link
profile disable host       # remove that use case's links
profile overlay add <dir>  # register a private overlay repo, then link
profile overlay remove <dir>
profile usecases           # list use cases defined here and in overlays
```

Everything is idempotent. A real file in the way is **moved** to
`~/.local/state/profile/backup/<timestamp>/<same path>` before linking, never
overwritten or deleted. Choices are stored per machine in `~/.config/profile/`
(`usecases`, `overlays`), not in the repo.

## Lifecycle

The whole life of a machine, in order. Each step is safe to re-run.

### 1. Set up
Follow [docs/bootstrap.md](docs/bootstrap.md): clone (outside synced folders),
`install.sh --dry-run`, then `install.sh`, `profile enable <usecases>`, and
`profile overlay add <dir>` if this machine gets an overlay. Finish with
`profile check` and a **new** terminal.

### 2. Change something (on any personal machine)
1. **Edit the live file**, e.g. `~/.config/starship.toml`. It's a symlink, so you're editing the clone. starship and byobu pick changes up immediately; zsh needs `exec zsh`.
2. **Review:** `git -C <clone> status` and `git -C <clone> diff`.
   Tools with their own settings menus write through the links too: byobu's F9 menu and Shift-F5 status cycling both rewrite `byobu/*`. Check `git status` after using them, and `git checkout -- <file>` anything you didn't mean to keep.
3. **Commit and push.** See [Committing](#committing): gitleaks plus the overlay's deny list, signed commits, files staged by name.

New files, zsh fragments and use cases are covered in [Changing things](#changing-things).

### 3. Update the other machines
```sh
profile update
```
It runs `git pull --ff-only` in this repo and every overlay that has an
upstream, prints the commits that arrived, then runs `profile link`:
- **Content changes** to already-linked files are live as soon as the pull lands. Open a new shell, or run `exec zsh`.
- **New manifest lines** get linked by the link step.
- **Overlays that aren't git clones** (a corporate machine's local overlay) are skipped.
- **Exit 1** means a pull failed. Read git's message just above:
  - *Authentication:* private overlays pull over SSH, so the agent must be unlocked, and 1Password may need approval on the machine's own screen. Running `profile update` from a local terminal there avoids this.
  - *Local changes or divergence:* commit and push them, or `git stash`, then re-run. It never merges.

`profile update` pulls into the clone that's running it; that's safe, because
git replaces files rather than rewriting them in place.

### 4. Check for drift
```sh
profile check    # "all links ok", or each broken link and exit 1
profile link     # repairs: relinks, backs up anything in the way, fixes ssh-unfriendly permissions
```
A link usually breaks because something replaced it with a plain file: an
installer (oh-my-zsh without `KEEP_ZSHRC=yes`) or a provisioner copying over it.
Stop that tool managing the path, then `profile link`.

### 5. Change what a machine is for
```sh
profile enable host          # add a use case
profile disable dev          # remove its links; zsh fragments stop loading in new shells
profile overlay add <dir>    # add an overlay
profile overlay remove <dir> # remove its links and unregister it
```

### 6. Retire a machine, or take the profile off it
There's no uninstall command. `base` can't be disabled, so do it by hand:
```sh
profile status                                   # what's linked, from where
profile overlay remove <dir>                     # once per overlay (removes its links, including base ones)
for uc in $(profile usecases); do [ "$uc" = base ] || profile disable "$uc"; done
# remove the base links (each is a symlink into the clone; check before deleting)
for f in ~/.zshrc ~/.zshenv ~/.config/starship.toml ~/.config/git/config ~/.config/git/ignore \
         ~/.config/git/os.gitconfig ~/.config/git/signing.gitconfig ~/.ssh/config \
         ~/.ssh/allowed_signers ~/.local/bin/profile; do [ -L "$f" ] && rm "$f"; done
ls ~/.local/state/profile/backup/                # one directory per run that replaced files
cp -a ~/.local/state/profile/backup/<timestamp>/. ~/   # restore that run's originals
rm -rf ~/.config/profile                         # forget use cases and overlays
```
Restore from the **earliest** backup directory to get the pre-profile files.
Later directories hold whatever a later run replaced. Remove the clones last.

## How it works

### Layout
```
links                  manifest: <usecase> <os> <source> <target>
install.sh             bootstrap entry point = `bin/profile link`
bin/profile            the linker (bash 3.2-compatible: runs on stock macOS)
zsh/zshrc              → ~/.zshrc   (the only zsh file that's linked)
zsh/zshenv             → ~/.zshenv  (mise shims on PATH for non-interactive zsh)
zsh/<usecase>/NN-*.zsh fragments; zsh/<usecase>/<darwin|linux>/NN-*.zsh for OS-specific ones
starship/ alacritty/ byobu/   app config, linked file by file
git/config             → ~/.config/git/config, plus per-OS / per-use-case includes
ssh/config             → ~/.ssh/config   (no hosts; includes ~/.ssh/config.d/*.conf)
.githooks/pre-commit   secret scan (enabled by `profile link` via core.hooksPath)
.gitleaks.toml         public scan rules
docs/bootstrap.md      machine setup playbook
```

### Manifest
One link per line, whitespace-separated, `#` for comments:
```
base   all     zsh/zshrc                   ~/.zshrc
host   all     byobu/status                ~/.byobu/status
desktop linux  alacritty/alacritty.toml    ~/.config/alacritty/alacritty.toml
```
`<os>` is `all`, `darwin` or `linux`. Only **files** are linked, never
directories, so apps can keep writing runtime files next to their config (byobu
does). Paths may not contain spaces.

### zsh loading
`~/.zshrc` resolves its own symlink to find the repo. It then sources, **sorted by
filename across all of them**, every `zsh/<usecase>/*.zsh` and
`zsh/<usecase>/<os>/*.zsh` for `base` plus the enabled use cases, from this
repo and then each overlay. `~/.zshrc.local` runs last. Enabling a zsh-only use
case therefore needs no new links. The number prefix decides where a fragment runs:

| prefix | stage |
|---|---|
| `05` | early environment (e.g. `LANG` on macOS) |
| `10` | `path` / `fpath` (before compinit) |
| `2x` | oh-my-zsh settings and the `plugins` array (use cases append with `plugins+=(…)`) |
| `40` | load oh-my-zsh, or plain `compinit` if it's absent |
| `45` | history (after oh-my-zsh, which sets its own) |
| `5x` | aliases and functions |
| `60` | `EDITOR` (`code -w` with a local display, else `nano`) |
| `70` | fzf, mise, starship (or the fallback prompt) |
| `90` | zsh-autosuggestions, then zsh-syntax-highlighting, which must be last |

### Layering: what wins
- **zsh:** repo fragments → overlay fragments (same sort) → `~/.zshrc.local`.
- **git:** `~/.config/git/config` (repo) → its includes `~/.config/git/os.gitconfig` and `signing.gitconfig` (linked per OS / use case) → `~/.gitconfig` (machine-local, read last, **wins**).
- **ssh:** `~/.ssh/config.d/*.conf` (machine-local or overlay) are included **first**, so a host's own settings beat the skeleton's defaults. ssh uses the first value it sees. The 1Password agent is only used where its socket exists, so a forwarded agent still works elsewhere.
- **Not managed, on purpose:** `~/.zprofile` (Homebrew `shellenv`, byobu auto-launch, provisioner blocks), `~/.gitconfig`, `~/.ssh/config.d/`, and anything a provisioner owns.

## Changing things

- **Edit a linked file:** just edit it (the live path is a symlink), then commit.
- **Add a dotfile:** put it in a directory named after the app, add a line to `links` with the narrowest use case and OS that fit, then `profile link` and `profile status`.
- **Add a zsh fragment:** `zsh/<usecase>/NN-name.zsh`, or `zsh/<usecase>/<os>/NN-name.zsh`. Pick `NN` from the table above. Guard every tool with `(( $+commands[tool] ))` so `base` stays dependency-free.
- **Add a use case:** create `zsh/<name>/` and/or add `links` lines tagged `<name>`. It exists as soon as either does (`profile usecases`).
- **Anything machine-specific or private:** `~/.zshrc.local`, `~/.ssh/config.d/`, `~/.gitconfig`, or the private overlay. Not here.

### Testing a change without touching your real home
```sh
T=$(mktemp -d)
HOME=$T ~/code/profile/bin/profile enable dev host
HOME=$T ~/code/profile/bin/profile check
HOME=$T script -qec "zsh -i -c 'print OK'" /dev/null   # real pty; any startup error shows up here
```
Then, for real: `profile link`, and open a **new** terminal to confirm the
prompt renders with no errors.

## Committing

1. **gitleaks must be installed** (`mise use -g gitleaks@latest` or `brew install gitleaks`). The hook refuses to commit without it.
2. **The private overlay must be registered** (`profile overlay add ~/code/profile-private`). The hook runs two passes over staged changes:
   - `.gitleaks.toml`: gitleaks' defaults plus RFC1918/CGNAT IP literals, `op://` references, 1Password tokens and credential assignments.
   - The overlay's `gitleaks/denylist.toml`: named domains, machines and employers. The list lives in the private overlay because publishing it would be the leak.

   Without the overlay the hook refuses, unless `PROFILE_SKIP_DENYLIST=1` is set for that one commit.
3. **Commits are signed** with the 1Password SSH key (`commit.gpgsign = true`). If signing fails, unlock 1Password. On a machine without it, forward your agent.
4. **Stage files by name** and read `git diff --cached --name-status` before committing. Never `git add -A` blind.

`profile link` sets `core.hooksPath=.githooks`. If you cloned without linking,
run it once before your first commit.

## Overlays

A private overlay is a repo with the same shape: a `links` manifest (use cases
and OS as above, sources relative to the overlay), optional `zsh/<usecase>/`
fragments, and for the deny list `gitleaks/denylist.toml`. Register it with
`profile overlay add <dir>`.
- **Personal overlay:** `abradner/profile-private` (private) holds SSH hosts, internal names and the deny list.
- **Corporate machines:** keep a local-only overlay directory with the same layout, never pushed to a personal account.

## Design notes

- **Symlinks from a manifest,** not a bare repo on `~` (explicitly not wanted) or GNU stow (no backup of real files, needs stow everywhere, folds directories so runtime files leak into the repo).
- **Public core + private overlay,** because a fresh machine can clone a public repo before any credentials exist. Encrypting secrets inside a public repo was rejected: one mistake is permanent.
- **Starship everywhere, oh-my-zsh kept** for its plugins; the git plugin aliases (`gcmsg`, `gco`, …) are heavily used.
- **Provisioners must not copy over linked paths.** `install -D` and `cp` replace a symlink with a plain copy, which silently undoes a link. A provisioner should call `profile` instead (clone as the target user, `bin/profile enable …`, `profile check` in its doctor).
- **History started fresh** in 2026. The 2015–2022 bash/Mac-bootstrap history is archived privately.
