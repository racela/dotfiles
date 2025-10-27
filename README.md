# Dotfiles
This is a repository of how I setup my environment for Arch Linux and macOS.

## Arch Linux Config
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
		 `sudo modprobe i2c-dev`
12. ghostty
13. spicetify
14. firefox

## macOS Config
1. ghostty
2. spicetify
3. chrome

## Terminal (Ghostty) Setup Guide

### 1. [Ghostty](https://github.com/ghostty-org/ghostty)

**Arch Linux:**
`sudo pacman -S ghostty`

**macOS:**
`brew install ghostty`

### 2. Zsh

**Arch Linux:**
```
sudo pacman -S zsh
chsh -s $(which zsh)
```
**macOS:**
> Zsh is already the default shell on macOS

### 3. [oh-my-zsh](https://github.com/ohmyzsh/ohmyzsh)
Install oh-my-zsh:

`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

Install oh-my-zsh plugins:

```
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

### 4. [Starship](https://github.com/starship/starship)

**Arch Linux:**
`sudo pacman -S starship`

**macOS:**
`brew install starship`

### 5. [Neovim](https://github.com/neovim/neovim)

**Arch Linux:**
`sudo pacman -S neovim`

**macOS:**
`brew install neovim`

### 6. [tmux](https://github.com/tmux/tmux/wiki)

**Arch Linux:**
`sudo pacman -S tmux`

**macOS:**
`brew install tmux`

### 7. [spicetify](https://github.com/spicetify)

**Arch Linux:**
`sudo pacman -S spicetify`

**macOS:**
`brew install spicetify`

### 8. [GNU Stow](https://www.gnu.org/software/stow/)

`sudo pacman -S stow`
`brew install stow`

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
### 2. Install plugins
```
tmux			 # launch tmux
<leader>+SHIFT+I # command to install plugins
```

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

## Create symlinks:

```
stow -t ~ common
stow -t ~ `<arch|linux>`
```

## Neovim Plugins:
These will be installed automatically by Neovim once launched
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [oil.nvim](https://github.com/stevearc/oil.nvim)
- [telescope](https://github.com/nvim-telescope/telescope.nvim)
- [treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [nordic.nvim](https://github.com/AlexvZyl/nordic.nvim)
- [lualine](https://github.com/nvim-lualine/lualine.nvim)
- [mason](https://github.com/mason-org/mason.nvim)
- [nvim-lspconfig](https://github.com/neovim/nvim-lspconfig)
- [mason-lspconfig](https://github.com/mason-org/mason-lspconfig.nvim)
- [none-ls](https://github.com/nvimtools/none-ls.nvim)
- [mason-null-ls](https://github.com/jay-babu/mason-null-ls.nvim)
- [cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp)
- [nvim-cmp](https://github.com/hrsh7th/nvim-cmp)

## Tmux Plugins:
These will be installed by tmux after running `<leader>+SHIFT+I` inside tmux
- [tpm](https://github.com/tmux-plugins/tpm)
- [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [nord-tmux](https://github.com/nordtheme/tmux)

## Other tools I use:
- [raycast (Mac)](https://www.raycast.com/)
- [yazi](https://github.com/sxyazi/yazi)
- [zoxide](https://github.com/ajeetdsouza/zoxide)
- [jq](https://github.com/jqlang/jq)
- [htop](https://github.com/htop-dev/htop)


