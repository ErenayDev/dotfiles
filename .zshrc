# Performance options
setopt no_flow_control share_history hist_expire_dups_first hist_ignore_dups
setopt hist_verify inc_append_history extended_history auto_cd auto_pushd
setopt pushd_ignore_dups correct extended_glob complete_in_word always_to_end
setopt path_dirs auto_menu auto_list auto_param_slash no_menu_complete
setopt interactive_comments

# History
HISTFILE=$HOME/.zsh_history
SAVEHIST=50000
HISTSIZE=50000

# Paths
typeset -U path
path=(
    /opt/flutter/bin
    /bin /usr/bin /usr/local/bin /sbin
    $HOME/.local/bin $HOME/.cargo/bin $HOME/go/bin $HOME/.bun/bin
    $HOME/.spicetify $HOME/.pyenv/bin $HOME/.encore/bin $HOME/.deno/bin
    $HOME/Android/Sdk/cmdline-tools/latest/bin $HOME/Android/Sdk/platform-tools
    /opt/gradle/bin
    /opt/nvim-linux-x86_64/bin
    $path
)

# Environment variables
export PYENV_ROOT="$HOME/.pyenv"
export ENCORE_INSTALL="$HOME/.encore"
export ANDROID_HOME="$HOME/Android/Sdk"
export ANDROID_SDK_ROOT="$HOME/Android/Sdk"
export GRADLE_HOME="/opt/gradle"
export JAVA_HOME="/usr/lib/jvm/java-21-openjdk"
export CHROME_EXECUTABLE="/bin/brave-browser"
export MICRO_TRUECOLOR=1
export VDPAU_DRIVER=radeonsi
export BAT_THEME="tokyonight_night"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border --preview "bat --color=always --style=header,grid --line-range :300 {}"'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -f $ZINIT_HOME/zinit.zsh ]] || source "$ZINIT_HOME/zinit.zsh"

# Completion
autoload -Uz compinit
() {
    setopt local_options EXTENDED_GLOB
    local zcompdump="$HOME/.zcompdump"
    if [[ $zcompdump(#qNmh+24) ]]; then
        compinit -d "$zcompdump"
    else
        compinit -C -d "$zcompdump"
    fi
}

# FZF
[[ -f /usr/share/fzf/key-bindings.zsh ]] && source /usr/share/fzf/key-bindings.zsh
[[ -f /usr/share/fzf/completion.zsh ]] && source /usr/share/fzf/completion.zsh

# Zinit plugins
zinit wait lucid light-mode for \
    atinit"zicompinit; zicdreplay" \
        zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
        zsh-users/zsh-autosuggestions \
    blockf atpull'zinit creinstall -q .' \
        zsh-users/zsh-completions

zinit wait lucid for \
    OMZ::lib/git.zsh \
    atload"unalias grv 2>/dev/null" \
        OMZ::plugins/git/git.plugin.zsh

# Region selection functions
r-delregion() {
    if ((REGION_ACTIVE)) then
        zle kill-region
    else
        local widget_name=$1
        shift
        zle $widget_name -- $@
    fi
}

r-deselect() {
    ((REGION_ACTIVE = 0))
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

r-select() {
    ((REGION_ACTIVE)) || zle set-mark-command
    local widget_name=$1
    shift
    zle $widget_name -- $@
}

# Key binding configuration
for key kcap seq mode widget (
    sleft   kLFT   $'\e[1;2D' select   backward-char
    sright  kRIT   $'\e[1;2C' select   forward-char
    sup     kri    $'\e[1;2A' select   up-line-or-history
    sdown   kind   $'\e[1;2B' select   down-line-or-history
    send    kEND   $'\E[1;2F' select   end-of-line
    send2   x      $'\E[4;2~' select   end-of-line
    shome   kHOM   $'\E[1;2H' select   beginning-of-line
    shome2  x      $'\E[1;2~' select   beginning-of-line
    left    kcub1  $'\EOD'    deselect backward-char
    right   kcuf1  $'\EOC'    deselect forward-char
    end     kend   $'\EOF'    deselect end-of-line
    end2    x      $'\E4~'    deselect end-of-line
    home    khome  $'\EOH'    deselect beginning-of-line
    home2   x      $'\E1~'    deselect beginning-of-line
    csleft  x      $'\E[1;6D' select   backward-word
    csright x      $'\E[1;6C' select   forward-word
    csend   x      $'\E[1;6F' select   end-of-line
    cshome  x      $'\E[1;6H' select   beginning-of-line
    cleft   x      $'\E[1;5D' deselect backward-word
    cright  x      $'\E[1;5C' deselect forward-word
    del     kdch1   $'\E[3~'  delregion delete-char
    bs      x       $'^?'     delregion backward-delete-char
) {
    eval "key-$key() {
        r-$mode $widget \$@
    }"
    zle -N key-$key
    bindkey ${terminfo[$kcap]-$seq} key-$key
}

bindkey -M isearch '^?' backward-delete-char

# Additional key bindings
(( $+functions[fzf-history-widget] )) && bindkey '^R' fzf-history-widget
(( $+functions[fzf-file-widget] )) && bindkey '^T' fzf-file-widget
(( $+functions[fzf-cd-widget] )) && bindkey '^[c' fzf-cd-widget

# Aliases
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --color=always --group-directories-first --icons'
alias la='eza -a --color=always --group-directories-first --icons'
alias lt='eza -aT --color=always --group-directories-first --icons --git-ignore'
alias l='eza -F --color=always --group-directories-first --icons'
alias cat='bat --style=plain --theme="tokyonight_night" --paging=never'
alias find='fd'
alias grep='rg'
alias ps='procs'
alias top='btop'
alias htop='btop'
alias du='dust'
alias df='duf'

# Git aliases
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gs='git status'
alias gd='git diff'
alias gb='git branch'
alias gco='git checkout'
alias gcm='git commit -m'
alias gaa='git add .'
alias glog='git log --oneline --graph'

# Navigation aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cl='clear'
alias rel='exec zsh'
alias vim='nvim'
alias vi='nvim'

# Functions
fcd() {
    local dir
    dir=$(fd --type d 2>/dev/null | fzf --preview 'eza --tree --color=always {} | head -200' +m) && cd "$dir"
}

fvim() {
    local file
    file=$(fzf --preview 'bat --color=always --style=header,grid --line-range :300 {}' +m) && nvim "$file"
}

fkill() {
    local pid
    pid=$(ps aux | sed 1d | fzf -m | awk '{print $2}') && kill -9 "$pid"
}

fhistory() {
    local cmd
    cmd=$(history | fzf --tac --no-sort | sed 's/ *[0-9]* *//') && eval "$cmd"
}

fman() {
    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | xargs -r man
}

mkcd() { mkdir -p "$1" && cd "$1" }
backup() { cp "$1"{,.bak} }

extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)           echo "'$1' cannot be extracted" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

lazy_load() {
    local command=$1
    local load_command=$2
    eval "$command() { unfunction $command; $load_command; $command \$@ }"
}

lazy_load pyenv 'eval "$(pyenv init -)"'

# Tool initialization
eval "$(zoxide init zsh --cmd cd)"
eval "$(starship init zsh)"
eval "$(fnm env --use-on-cd)"

# External sources
[[ -f ~/.couchdb-workspace ]] && source ~/.couchdb-workspace
[[ -f ~/.bun/_bun ]] && source ~/.bun/_bun
[[ -f ~/.deno/env ]] && source ~/.deno/env

rustormy -c Kocasinan

# bun completions
[ -s "/home/erenay/.bun/_bun" ] && source "/home/erenay/.bun/_bun"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
