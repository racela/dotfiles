# Shared interactive shell. Machine-specific settings belong in ~/.zshrc.local.
if [[ "$OSTYPE" == darwin* ]]; then
  for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$brew_path" ]]; then
      eval "$("$brew_path" shellenv)"
      break
    fi
  done
  unset brew_path
fi
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode disabled
plugins=(git)
for plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  [[ -f "$ZSH/custom/plugins/$plugin/$plugin.plugin.zsh" ]] && plugins+=("$plugin")
done
unset plugin
[[ -f "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"
bindkey -v
(( $+commands[fzf] )) && source <(fzf --zsh)
export EDITOR=nvim
(( $+commands[nvim] )) || export EDITOR=vim
export VISUAL="$EDITOR"
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[starship] )) && eval "$(starship init zsh)"
typeset -U path
path=("$HOME/.local/bin" "$HOME/.spicetify" $path)
if [[ -f "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
