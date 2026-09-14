# Bootstrapping a machine

Take a machine from nothing to a fully set-up profile, one step at a time.
Every step ends with a check. Everything after step 2 is optional, and each
step works without the ones after it. That's deliberate: `base` has to work
on a bare server with nothing extra installed.

Run the commands **in a real terminal on the target machine**. `chsh` and
`sudo` prompt for a password, and a runner without a tty (such as Claude
Code's `!` prefix) can't answer those prompts.

- [Debian / Ubuntu](#debian--ubuntu)
- [macOS](#macos)
- [Adopting a machine that already has dotfiles](#adopting-a-machine-that-already-has-dotfiles)
- [Private overlay](#private-overlay)
- [Troubleshooting](#troubleshooting)

---

## Debian / Ubuntu

Verified end to end on Ubuntu Server 26.04 (no desktop) and Raspberry Pi OS
(Debian 13) with a desktop.

### 1. Prerequisites: git and zsh
```sh
command -v git zsh || sudo apt install -y git zsh
```
**Check:** both paths print.

### 2. Clone and link base
```sh
mkdir -p ~/code
git clone https://github.com/abradner/profile.git ~/code/profile
~/code/profile/install.sh --dry-run    # read what it will do
~/code/profile/install.sh
```
**Check:** `~/code/profile/bin/profile check` prints `all links ok`. Any file
that was replaced is under `~/.local/state/profile/backup/<timestamp>/`.

> Existing `~/.ssh/config`? It gets backed up and replaced by a skeleton that
> holds no hosts. Move your `Host` blocks into `~/.ssh/config.d/<name>.conf`
> (or the private overlay) before you next need them. See
> [Adopting a machine](#adopting-a-machine-that-already-has-dotfiles).

### 3. Make zsh the login shell
```sh
chsh -s "$(command -v zsh)"
```
**Check:** open a **new** SSH session or terminal. `echo $0` prints `-zsh`,
and the prompt is the plain fallback `user@host:~$` with no errors above it.

### 4. Packages from apt (sudo)
```sh
sudo apt update
sudo apt install -y lsd prettyping fzf bat pigz zsh-autosuggestions zsh-syntax-highlighting
```
**Check:** `command -v lsd prettyping fzf batcat pigz`. If apt doesn't have a
package on some release, skip it: every alias and integration is guarded and
disappears when its tool is missing.

### 5. oh-my-zsh (no sudo)
```sh
RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
```
Keep `KEEP_ZSHRC=yes`. Without it the installer moves the linked `~/.zshrc`
aside and writes its own template.

**Check:** `ls -la ~/.zshrc` still points into `~/code/profile`, and
`profile check` is still ok.

### 6. starship (no sudo)
```sh
curl -sS https://starship.rs/install.sh | sh -s -- -y -b ~/.local/bin
```
**Check:** `~/.local/bin/starship --version`. The prompt uses Nerd Font
glyphs, which the terminal you connect *from* has to render.

### 7. mise (optional, no sudo)
```sh
curl https://mise.run | sh
```
**Check:** `~/.local/bin/mise --version`.

### 8. Reload
```sh
exec zsh -l
```
**Check:**
- The starship prompt appears, and `ll` lists with lsd.
- Ctrl-R opens fzf.
- Autosuggestions show in grey, and commands are syntax-highlighted.
- No errors appear above the prompt.

### 9. Use cases
Enable only what this machine is for:
```sh
profile enable host      # byobu config: machines that hold long-running sessions
profile enable dev       # dev oh-my-zsh plugins, single-letter aliases, rails helpers
profile enable desktop   # alacritty + 1Password commit signing (needs a local GUI + 1Password)
```
**Check:** `profile status` shows every enabled line as `ok`. For `dev`,
open a new shell and `alias k lg` prints both.

Optional: land every interactive login inside byobu. The profile deliberately
doesn't manage `~/.zprofile`, so add the line yourself:
```sh
echo '_byobu_sourced=1 . /usr/bin/byobu-launch 2>/dev/null || true' >> ~/.zprofile
```

### 10. Final check
```sh
profile check && profile status
```
Then open a **new** connection: it should go straight to the prompt (or byobu)
with no errors.

---

## macOS

> Not yet verified end to end on a Mac. The config is written for macOS
> (stock bash 3.2 linker, Homebrew paths, the 1Password agent path), but
> follow this with care and fix the doc where it's wrong.

### 1. Prerequisites
- Xcode command-line tools: `xcode-select --install` (provides git).
- [Homebrew](https://brew.sh). Its `shellenv` line belongs in `~/.zprofile`, which the profile leaves alone.
- zsh is already the default login shell. Check with `echo $SHELL`.

### 2. Tools
```sh
brew install starship fzf lsd prettyping bat pigz mise gitleaks \
  zsh-autosuggestions zsh-syntax-highlighting
```

### 3. oh-my-zsh
Same command as [Debian step 5](#5-oh-my-zsh-no-sudo), with `KEEP_ZSHRC=yes`.

### 4. Clone and link
```sh
mkdir -p ~/code
git clone https://github.com/abradner/profile.git ~/code/profile
~/code/profile/install.sh --dry-run
```
**Read the dry run before applying.** On a Mac that's been in use,
`~/.zshrc`, `~/.ssh/config` and `~/.config/starship.toml` probably exist.
Work through [Adopting a machine](#adopting-a-machine-that-already-has-dotfiles)
first, then run:
```sh
~/code/profile/install.sh
profile enable dev host   # as appropriate; `desktop` is Linux-only today
```
The macOS 1Password signing and gh credential-helper includes are part of
`base` on darwin.

### 5. Check
Open a new terminal:
- The starship prompt appears, with no errors.
- `git config --get gpg.ssh.program` points at `/Applications/1Password.app/…/op-ssh-sign`.
- `ssh -G github.com | grep identityagent` shows the 1Password socket.

---

## Adopting a machine that already has dotfiles

The linker never deletes anything, but a replaced file stops being read. Before
running `install.sh` on a machine that's been in use:

1. **`~/.zshrc`.** Move machine-only lines into `~/.zshrc.local`, which is sourced last. That includes IDE and tool-installer additions (Docker Desktop, JetBrains, Antigravity, bun completions), work aliases, and anything with a hostname or secret. A p10k setup can stay on disk, but the profile uses starship.
2. **`~/.ssh/config`.** Move every `Host` block into `~/.ssh/config.d/<name>.conf`, or into the private overlay if more than one machine should share it. The skeleton includes `~/.ssh/config.d/*.conf` first, so those hosts still win over its defaults.
3. **`~/.gitconfig`.** Leave it. Git reads it after `~/.config/git/config`, so its values win. Remove any duplicates you no longer want.
4. **Secrets in shell files** (passwords in `MAVEN_OPTS` and the like) never go in either repo. Keep them in 1Password and load them in `~/.zshrc.local` with `op read` / `op inject`.

After linking, compare against the backup:
`diff ~/.local/state/profile/backup/<timestamp>/.zshrc ~/.zshrc`.

---

## Private overlay

Machine names, internal domains, SSH hosts and the secret-scan deny list live in
a private repo with the same layout (`links` manifest, `zsh/<usecase>/`).
Clone it once GitHub access works (e.g. 1Password unlocked):
```sh
git clone git@github.com:abradner/profile-private.git ~/code/profile-private
profile overlay add ~/code/profile-private
```
**Check:** `profile status` lists the overlay.

**Who needs it:** any machine you **commit to the public repo from**. Without
it, the pre-commit hook refuses to commit (see the main README).

Corporate machines don't clone the personal overlay. Keep a local-only
directory with the same layout and register it the same way.

---

## Troubleshooting

| Symptom | Cause / fix |
|---|---|
| `chsh: PAM: Authentication failure` with no prompt shown | No tty. Run it in a real terminal. |
| `~/.zshrc` is a regular file again after installing oh-my-zsh | The installer ran without `KEEP_ZSHRC=yes`. Run `profile link`; it backs up the template and relinks. |
| A link keeps turning back into a plain file | A provisioning tool is copying over it. Anything using `install -D` or `cp` replaces a symlink with a copy. Stop that tool managing the path, then `profile link`. |
| `Bad owner or permissions on ~/.ssh/config` | The repo file is group-writable (umask 002). `profile link` runs `chmod go-w` on every linked file; re-run it. |
| `mise ERROR No version is set for shim: node` | `~/.zshenv` puts mise shims on PATH. Outside a project that pins a version, set a global one (`mise use -g node@lts`) or ignore it. |
| Commit fails with `No private key found` / signing errors | `commit.gpgsign` is on everywhere. On a machine without 1Password, forward your agent (`ssh -A`) or commit elsewhere. |
| `pre-commit: gitleaks not found` | `mise use -g gitleaks@latest` or `brew install gitleaks`. |
| `pre-commit: no private overlay…` | Register the overlay (above), or set `PROFILE_SKIP_DENYLIST=1` for that commit knowingly. |
| Slow startup with `dev` | oh-my-zsh's kubectl/docker plugins refresh completions in the background on each start. Compare `profile disable dev` to measure. |
