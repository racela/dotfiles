# Dotfiles
This is a repository of how I setup my environment for Arch Linux and MacOS.

## Prerequisites

Ensure these are installed as these are the applications that will be configured by this repo
### 1. [Ghostty](https://github.com/ghostty-org/ghostty)

`sudo pacman -S ghostty`

### 2. Zsh

```
sudo pacman -S zsh
chsh -s $(which zsh)
```

### 3. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
Install oh-my-zsh:

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

Install oh-my-zsh plugins:

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 4. [Starship](https://github.com/starship/starship)

`sudo pacman -S starship`

### 5. [Neovim](https://github.com/neovim/neovim)

`sudo pacman -S neovim`

### 6. [tmux](https://github.com/tmux/tmux/wiki)

`sudo pacman -S tmux`

### 7. [spicetify](https://github.com/spicetify)

`sudo pacman -S spicetify`

### 8. [GNU Stow](https://www.gnu.org/software/stow/)

`sudo pacman -S stow`

## Arch Linux Prerequisites

*Might move Arch Linux install to another doc
1. sddm
2. hyprland
3. hyprpaper
4. hypridle
5. hyprshot
6. hyprpicker
7. dolphin
8. waybar
9. wofi
10. swaync
11. ddcutil
	* `sudo modprobe i2c-dev`

## Create symlinks:

```
stow -t ~ common
stow -t ~ `<arch|linux>`
```


## Neovim Prerequisites:
### 1. [fzf](https://github.com/junegunn/fzf)
`sudo pacman -S fzf`
### 2. [ripgrep](https://github.com/BurntSushi/ripgrep)
`sudo pacman -S ripgrep`
### 3. [fd](https://github.com/sharkdp/fd)
`sudo pacman -S fd`
### 4. [node](https://nodejs.org/en/download)
Follow link to install latest version
### 5. [unzip](https://archlinux.org/packages/extra/x86_64/unzip/)
`sudo pacman -S unzip`
### 6. [terraform-ls](https://github.com/hashicorp/terraform-ls)
Not available for Arch Linux
### 7. [Iosevka font](https://github.com/be5invis/Iosevka)
`sudo pacman -S ttc-iosevka`

## Tmux Prerequisites:
### 1. tpm
`git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm`

## Spicetify Prerequities:
### 1. Spotify
`sudo pacman -S spotify-launcher`

## Install Spicetify:
```
curl -fsSL https://raw.githubusercontent.com/spicetify/cli/main/install.sh | sh
git clone --depth=1 https://github.com/spicetify/spicetify-themes.git
cp -r spicetify-themes/Dribbblish ~/.config/spicetify/Themes
spicetify update
```

## Neovim Plugins:
These will be installed automatically by Neovim once launched
- vim-tmux-navigator
- oil.nvim
- telescope
- treesitter
- nordic.nvim
- lualine
- mason
- nvim-lspconfig
- mason-lspconfig
- none-ls
- mason-null-ls
- cmp-nvim-lsp
- nvim-cmp

## Tmux Plugins:
These will be installed by tmux after running `<leader>+SHIFT+I` inside tmux
- tpm
- tmux-sensible
- vim-tmux-navigator
- nord-tmux

## Other tools I use:
- raycast (Mac)
- yazi
- zoxide
- jq
- htop

