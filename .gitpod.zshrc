# if in a script, go away
[ -z "$PS1" ] && return

function cd
{
  [ -z "$PS1" ] && return
  builtin cd "$@" && ls
}

export PATH=/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin:$PATH
source /usr/local/share/.zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoload colors; colors

#  If you type foo, and it isn't a command, and it is a directory in your cdpath, go there
setopt auto_cd
# Enable parameter expansion, command substitution, and arithmetic expansion in the prompt
setopt prompt_subst
# Perform implicit tees or cats when multiple redirections are attempted
setopt multios

# Setup terminal
export EDITOR=nano
export TERM=xterm-256color

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

_newline=$'\n'
_lineup=$'\e[1A'
_linedown=$'\e[1B '
PROMPT='┌─── %n @ ☁️ : %~/ ${vcs_info_msg_0_}${_newline}└%f'

autoload -U compinit && compinit
zmodload -i zsh/complist
autoload -Uz vcs_info

# man zshcontrib
zstyle ':vcs_info:*' enable git #svn cvs

# Enable completion caching, use rehash to clear
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST

# Fallback to built in ls colors
zstyle ':completion:*' list-colors ''

# Make the list prompt friendly
zstyle ':completion:*' list-prompt '%SAt %p: Hit TAB for more, or the character to insert%s'

# Make the selection prompt friendly when there are a lot of choices
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'

# Add simple colors to kill
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

# List of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select=1 _complete _ignored _approximate

# Match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# Formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# Ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle '*' single-ignored show

# Allow completion from within a word/phrase
setopt complete_in_word

 # Spelling correction for commands
setopt correct
# Spelling correction for arguments
setopt correctall

autoload -U +X bashcompinit && bashcompinit

source /usr/local/share/.zsh-history-substring-search/zsh-history-substring-search.zsh
bindkey "$terminfo[kcuu1]" history-substring-search-up
bindkey "$terminfo[kcud1]" history-substring-search-down

HISTSIZE=1000000
SAVEHIST=1000000
HISTFILE=~/.zsh_history
# Ignore commands that start with a space
HISTCONTROL=ignorespace

# Allow multiple terminal sessions to all append to one zsh command history
setopt append_history
# Save timestamp of command and duration
setopt extended_history
# Add commands as they are typed, don't wait until shell exit
setopt inc_append_history
# When trimming history, lose oldest duplicates first
setopt hist_expire_dups_first
# Do not write events to history that are duplicates of previous events
setopt hist_ignore_dups
# When searching history don't display results already cycled through twice
setopt hist_find_no_dups
# Remove extra blanks from each command line being added to history
setopt hist_reduce_blanks

autoload -Uz vcs_info
zstyle ':vcs_info:*' stagedstr '%F{green}•'
zstyle ':vcs_info:*' unstagedstr '%F{yellow}•'
zstyle ':vcs_info:*' check-for-changes true

precmd ()
{
  print ""

  # START GIT STATUS

  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
    zstyle ':vcs_info:*' formats '[%b] %c%u%f'
  else
    zstyle ':vcs_info:*' formats '[%b] %F{red}•%c%u%f'
  fi

  vcs_info

  # END GIT STATUS
}

# Aliases
alias tf="terraform "

# Load completion for terrafom docs
source <(terraform-docs completion zsh)

# Install Terraform autocomplete
terraform -install-autocomplete
