# Rafa’s dotfiles

A Nord-inspired terminal workspace for **Arch Linux and macOS**, with an optional personal Hyprland desktop on Arch.

**Zsh · Starship · Ghostty · tmux · Neovim**

Clone once, run the bootstrap, and keep your configuration in Git. The installer detects the OS, installs the shared tools, downloads pinned shell/tmux plugins, and links configs with GNU Stow. It works from any clone location, including paths containing spaces.

## Quick start

Start with an installed OS, internet access, and a normal user account with permission to install packages.

- **Arch:** install Git first with `sudo pacman -Syu --needed git`. The bootstrap uses `sudo pacman` for the remaining packages.
- **macOS:** install Apple’s command-line tools with `xcode-select --install`, then install [Homebrew](https://brew.sh/). Finish both before proceeding. The bootstrap finds Homebrew on Apple Silicon and Intel Macs.

```sh
git clone https://github.com/racela/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh --dry-run   # preview commands without changing anything
./bootstrap.sh
```

Run as yourself, **without `sudo`**. Package managers retain their normal prompts. On Arch, installation includes a full system upgrade to avoid partial upgrades.

Open `zsh` or Ghostty after setup. To make Zsh your login shell on Arch:

```sh
chsh -s "$(command -v zsh)"
```

Log out and back in after changing the login shell. macOS already uses Zsh by default.

Launch `nvim` once with internet access: Lazy installs the editor plugins and Mason installs configured language tools. Use `:Lazy restore` to restore plugin revisions from `lazy-lock.json`, and `:checkhealth` to diagnose missing editor dependencies. Language-tool and parser downloads can take a few minutes.

## What gets installed

| Component | Setup |
| --- | --- |
| Shell | Shared Zsh config, Oh My Zsh, autosuggestions, syntax highlighting, Starship, zoxide, fzf |
| Terminal | [Ghostty](https://formulae.brew.sh/cask/ghostty), Nord theme, [Iosevka](https://formulae.brew.sh/cask/font-iosevka) font |
| Multiplexer | tmux, TPM, Nord theme, navigation, session save/restore plugins |
| Editor | Neovim config, Lazy lockfile, Mason language tools |
| Utilities | Git, curl, ripgrep, fd, jq, htop, yazi, Node/npm, Python, unzip |
| Arch desktop | Optional: Hyprland, Waybar, launcher, notifications, wallpaper, idle/lock tools, audio and screenshot dependencies |

The default setup links `common/` and the platform’s `.zshrc`. It does not link personal desktop or Spotify settings.

## Existing machines and reruns

```sh
./bootstrap.sh --skip-packages                  # packages are already installed
./bootstrap.sh --skip-packages --skip-plugins   # only link configs; no downloads
./bootstrap.sh --unlink                         # remove core managed links
```

The bootstrap checks both Stow packages for conflicts before creating links. It stops if, for example, `~/.zshrc` or `~/.config/nvim/init.lua` is an existing file. Move the conflicting file or directory to a backup location you choose, then rerun. It never adopts, overwrites, or deletes your existing config files.

Package installation happens before the conflict check because Stow may need to be installed first. A failure can therefore leave installed packages; rerunning is safe. Existing plugin directories are kept, with a notice if their commit differs from the lockfile. Local plugin edits are preserved.

`--unlink` removes managed symlinks only. Installed packages, downloaded plugins, editor data and unrelated files remain. Keep the clone in place while using its symlinks; unlink before moving it, then run the bootstrap from the new location.

These packages use `~/.config`; a different `XDG_CONFIG_HOME` is rejected explicitly.

## Local settings

Put machine-specific paths, private environment variables and overrides in **`~/.zshrc.local`**, which is sourced last and is not managed by Stow:

```sh
# ~/.zshrc.local
export EDITOR=nvim
# export JAVA_HOME="..."
# export PATH="$HOME/my-tools/bin:$PATH"
```

The shared shell discovers Homebrew, uses `$HOME` instead of personal paths, and tolerates missing optional commands. Existing NVM installations are loaded if present; Node is otherwise supplied by the package manager.

## Optional Arch desktop

The desktop configs reflect a particular workstation. **Review the monitor/audio settings before enabling this profile on another machine.**

```sh
./bootstrap.sh --desktop --dry-run
./bootstrap.sh --desktop
```

The profile adds `pkglists/arch-desktop.txt` and links the Arch configs, except Spicetify and the saved nightTab export. To remove both the desktop and core links:

```sh
./bootstrap.sh --desktop --unlink
```

Machine-specific setup still matters:

- **Displays and audio:** the current `arch/.config/hypr/hyprland.lua`, legacy `hyprland.conf`, and audio scripts reference `DP-1`, `HDMI-A-1`, a TV and particular audio devices. Adjust these to your hardware and installed Hyprland version. The bootstrap preserves these personal settings.
- **Drivers and login:** install your GPU drivers and configure your display manager or session launcher for your machine. The bootstrap does not install kernels/bootloaders or enable system services. Bluetooth needs an enabled `bluetooth.service` when used.
- **Optional apps:** Steam (including Arch multilib setup), `wlogout`, and `waybar-module-pacman-updates-git` are not installed automatically. Review and install AUR packages with your preferred helper, or remove their Waybar modules. Steam is referenced by the personal desktop’s autostart.
- **Personal integrations:** the GitHub module targets `racela/home-server-argocd`. The Home Assistant module reads `~/.config/home-assistant/env` with `HA_URL`, `HA_TOKEN`, and `HA_AREA_ID`; keep this private file outside the repository and restrict its permissions.
- **Appearance:** custom GTK/Qt icon themes and SDDM styling are not bundled. Configure them separately if desired. The wallpaper is included.

The older `pkglists/pacman.txt` and `pkglists/aur.txt` are workstation snapshots, **not installation manifests**. They include hardware-specific and overlapping packages and are intentionally not consumed by the bootstrap.

## Spotify and browser extras

Spicetify configs are retained as references but excluded from installation because they contain machine-specific Spotify paths and state. Install Spotify and Spicetify separately, let Spicetify generate its local config, then adapt the bundled `arch/.config/spicetify/Themes/Dribbblish` theme as needed.

The nightTab JSON under `arch/.config/nightTab/` is a manual browser import, not an application config to symlink.

## Repository map

```text
bootstrap.sh          OS detection, package installation, safe Stow setup
Brewfile              macOS tools and font
plugins.lock          Exact commits for Zsh and tmux dependencies
common/               Shared editor, terminal, shell and tmux configs
arch/                 Arch shell entrypoint and personal desktop
mac/                  macOS shell entrypoint and Spotify reference config
pkglists/             Curated Arch manifests and historical snapshots
scripts/              Pinned plugin installer
tests/                Offline bootstrap integration tests
.github/workflows/    Linux/macOS validation
```

## Reproducibility and maintenance

The bootstrap repeats the same setup steps, package selection and links. Zsh/tmux downloads use exact commits in `plugins.lock`; Neovim plugins have `common/.config/nvim/lazy-lock.json`. Oh My Zsh’s automatic updater is disabled to keep its installed revision stable.

This is **not a bit-for-bit OS image**: Pacman and Homebrew install available package versions; Mason tools and Treesitter parsers are not version-pinned. Hardware, services and application sign-ins remain machine-specific.

To update deliberately:

1. Pull repo changes, inspect them, and rerun the bootstrap.
2. Change package manifests when adding a dependency.
3. Update `plugins.lock` with reviewed upstream commits. For an existing plugin, back up or move its directory before rerunning to install the new pinned revision; the installer never resets an existing checkout.
4. Update editor plugins through Lazy and commit the resulting lockfile after testing.

## Checks

With Python 3, GNU Stow, Bash and Zsh installed:

```sh
bash -n bootstrap.sh scripts/install-plugins.sh common/.config/ghostty/startup.sh
zsh -n common/.config/zsh/rc.zsh arch/.zshrc mac/.zshrc
python3 -m unittest discover -s tests -v
```

Tests use temporary home directories and local Git fixtures. They cover linking, reruns, conflicts, dry runs, unlinking, invalid options and pinned plugin installation without installing packages or downloading plugins. CI runs the tests and ShellCheck on Linux and macOS; it does not provision a full graphical desktop.
