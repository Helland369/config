# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/th/.zshrc'

autoload -Uz compinit
compinit

# make C-s not freeze the terminal
stty -ixon

# onmisharp path
export PATH="$HOME/.dotnet/tools:$PATH"

# alive lsp path
export PATH="$HOME/bin:$PATH"

# set edior
export EDITOR="nvim"

# ls with colours
alias ls="ls --color=auto"

# nvim vim
alias vim="nvim"

# emacs
alias emc="emacsclient -nw"
alias ema="emacsclient --create-frame"
alias em="emacs -nw"

# dot dot // go back one directory
alias ..="cd .."

alias sbcl="rlwrap sbcl"

#thefuck
eval $(thefuck --alias)

# keep pathe afther wuiting yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# git status for prompt
setopt PROMPT_SUBST

autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true

zstyle ':vcs_info:git:*' formats ' %b%m'
zstyle ':vcs_info:git:*' actionformats ' %b|%a%m'

zstyle ':vcs_info:git*+set-message:*' hooks git-status-numbers

+vi-git-status-numbers() {
  local staged unstaged ahead behind

  staged=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  unstaged=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

  if git rev-parse --abbrev-ref '@{upstream}' >/dev/null 2>&1; then
    local -a counts
    counts=(${(s: :)$(git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null)})
    ahead=${counts[1]}
    behind=${counts[2]}
  else
    ahead=0
    behind=0
  fi

  local flags=""

  (( staged > 0 ))   && flags+=" +${staged}"
  (( unstaged > 0 )) && flags+=" ~${unstaged}"
  (( ahead > 0 ))    && flags+=" ↑${ahead}"
  (( behind > 0 ))   && flags+=" ↓${behind}"

  if (( staged == 0 && unstaged == 0 && ahead == 0 && behind == 0 )); then
    flags+=" ✓"
  fi

  hook_com[misc]="${flags}"
}

precmd() { vcs_info }

# PS1 prompt
PS1='%F{magenta}%n@%m%f %F{blue}%~%f %F{yellow}${vcs_info_msg_0_}%f'$'\n''%(?.%F{green}.%F{red})(%?)%f λ '

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Set up zoxide completion
eval "$(zoxide init zsh)"

# fzf tab
# https://github.com/aloxaf/fzf-tab?tab=readme-ov-file
autoload -U compinit; compinit
source ~/fzf-tab/fzf-tab.plugin.zsh

# plugins

source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

## autosuggestion config
bindkey "^[^M" autosuggest-accept
