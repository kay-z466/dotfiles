# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=
# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

#--------------------------------------------------------------------------------------------------

export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth:erasedups
export PATH=$PATH:/home/linux/scripts
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
export FZF_DEFAULT_COMMAND='find .'
export FZF_COMPLETION_TRIGGER=',,'
export CALCURSE_EDITOR="vimx"
export EDITOR="vimx"
set -o vi
#Sets PROMPT_DIRTRIM for every shell login
export PROMPT_DIRTRIM=1

alias v="vimx"
alias ff="fastfetch"
alias ta='tmux attach-session'
alias vim="vimx"
alias c="clear"
alias e="exit"
alias n="nvim"
alias nm="NVIM_APPNAME=nvim_minimal nvim"
alias r="vifm"
alias l="lazygit"
alias b="btop"
alias f="fzf | xclip -selection clipboard"
alias fh='rg --hidden -l "" | fzf | xclip -selection clipboard'
alias todo='calcurse'
alias br='xbacklight -set'
alias vo='amixer -c 0 set Master ' 
alias t='tmux'
alias tk='tmux kill-server'
alias jo="join_files.sh"
alias fcd='cd "$(ls -d -A */ .*/ 2>/dev/null | fzf --reverse)"'
alias cf='cd "$(find . type -d 2>/dev/null| fzf)"'
alias xs="watch -n 1 sensors"
alias f="footclient -e vifm -c ":FZFfind""
if [[ $- == *i* ]]; then
    bind -m vi-command '"\e[A": history-search-backward'
    bind -m vi-command '"\e[B": history-search-forward'
    bind -m vi-insert '"\e[A": history-search-backward'
    bind -m vi-insert '"\e[B": history-search-forward'
fi

eval "$(zoxide init bash)"
#     ____      ____
#    / __/___  / __/
#   / /_/_  / / /_
#  / __/ / /_/ __/
# /_/   /___/_/ key-bindings.bash
#
# - $FZF_TMUX_OPTS
# - $FZF_CTRL_T_COMMAND
# - $FZF_CTRL_T_OPTS
# - $FZF_CTRL_R_OPTS
# - $FZF_ALT_C_COMMAND
# - $FZF_ALT_C_OPTS

if [[ $- =~ i ]]; then


# Key bindings
# ------------

__fzf_defaults() {
  # $1: Prepend to FZF_DEFAULT_OPTS_FILE and FZF_DEFAULT_OPTS
  # $2: Append to FZF_DEFAULT_OPTS_FILE and FZF_DEFAULT_OPTS
  echo "--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore $1"
  command cat "${FZF_DEFAULT_OPTS_FILE-}" 2> /dev/null
  echo "${FZF_DEFAULT_OPTS-} $2"
}

__fzf_select__() {
  FZF_DEFAULT_COMMAND=${FZF_CTRL_T_COMMAND:-} \
  FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse  --scheme=path" "${FZF_CTRL_T_OPTS-} -m") \
  FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) "$@" |
    while read -r item; do
      printf '%q ' "$item"  # escape special chars
    done
}

__fzfcmd() {
  [[ -n "${TMUX_PANE-}" ]] && { [[ "${FZF_TMUX:-0}" != 0 ]] || [[ -n "${FZF_TMUX_OPTS-}" ]]; } &&
    echo "fzf-tmux ${FZF_TMUX_OPTS:--d${FZF_TMUX_HEIGHT:-40%}} -- " || echo "fzf"
}

fzf-file-widget() {
  local selected="$(__fzf_select__ "$@")"
  READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$selected${READLINE_LINE:$READLINE_POINT}"
  READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
}

__fzf_cd__() {
  local dir
  dir=$(
    FZF_DEFAULT_COMMAND=${FZF_ALT_C_COMMAND:-} \
    FZF_DEFAULT_OPTS=$(__fzf_defaults "--reverse  --scheme=path" "${FZF_ALT_C_OPTS-} +m") \
    FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd)
  ) && printf 'builtin cd -- %q' "$(builtin unset CDPATH && builtin cd -- "$dir" && builtin pwd)"
}

if command -v perl > /dev/null; then
  __fzf_history__() {
    local output script
    script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
    output=$(
      set +o pipefail
      builtin fc -lnr -2147483648 |
        last_hist=$(HISTTIMEFORMAT='' builtin history 1) command perl -n -l0 -e "$script" |
        FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort ${FZF_CTRL_R_OPTS-} +m --read0") \
        FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) --query "$READLINE_LINE"
    ) || return
    READLINE_LINE=${output#*$'\t'}
    if [[ -z "$READLINE_POINT" ]]; then
      echo "$READLINE_LINE"
    else
      READLINE_POINT=0x7fffffff
    fi
  }
else # awk - fallback for POSIX systems
  __fzf_history__() {
    local output script n x y z d
    if [[ -z $__fzf_awk ]]; then
      __fzf_awk=awk
      # choose the faster mawk if: it's installed && build date >= 20230322 && version >= 1.3.4
      IFS=' .' read n x y z d <<< $(command mawk -W version 2> /dev/null)
      [[ $n == mawk ]] && (( d >= 20230302 && (x *1000 +y) *1000 +z >= 1003004 )) && __fzf_awk=mawk
    fi
    [[ $(HISTTIMEFORMAT='' builtin history 1) =~ [[:digit:]]+ ]]    # how many history entries
    script='function P(b) { ++n; sub(/^[ *]/, "", b); if (!seen[b]++) { printf "%d\t%s%c", '$((BASH_REMATCH + 1))' - n, b, 0 } }
    NR==1 { b = substr($0, 2); next }
    /^\t/ { P(b); b = substr($0, 2); next }
    { b = b RS $0 }
    END { if (NR) P(b) }'
    output=$(
      set +o pipefail
      builtin fc -lnr -2147483648 2> /dev/null |   # ( $'\t '<lines>$'\n' )* ; <lines> ::= [^\n]* ( $'\n'<lines> )*
        command $__fzf_awk "$script"           |   # ( <counter>$'\t'<lines>$'\000' )*
        FZF_DEFAULT_OPTS=$(__fzf_defaults "" "-n2..,.. --scheme=history --bind=ctrl-r:toggle-sort ${FZF_CTRL_R_OPTS-} +m --read0") \
        FZF_DEFAULT_OPTS_FILE='' $(__fzfcmd) --query "$READLINE_LINE"
    ) || return
    READLINE_LINE=${output#*$'\t'}
    if [[ -z "$READLINE_POINT" ]]; then
      echo "$READLINE_LINE"
    else
      READLINE_POINT=0x7fffffff
    fi
  }
fi

# Required to refresh the prompt after fzf
bind -m emacs-standard '"\er": redraw-current-line'

bind -m vi-command '"\C-z": emacs-editing-mode'
bind -m vi-insert '"\C-z": emacs-editing-mode'
bind -m emacs-standard '"\C-z": vi-editing-mode'

if (( BASH_VERSINFO[0] < 4 )); then
  # CTRL-T - Paste the selected file path into the command line
  if [[ "${FZF_CTRL_T_COMMAND-x}" != "" ]]; then
    bind -m emacs-standard '"\C-t": " \C-b\C-k \C-u`__fzf_select__`\e\C-e\er\C-a\C-y\C-h\C-e\e \C-y\ey\C-x\C-x\C-f"'
    bind -m vi-command '"\C-t": "\C-z\C-t\C-z"'
    bind -m vi-insert '"\C-t": "\C-z\C-t\C-z"'
  fi

  # CTRL-R - Paste the selected command from history into the command line
  bind -m emacs-standard '"\C-r": "\C-e \C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er"'
  bind -m vi-command '"\C-r": "\C-z\C-r\C-z"'
  bind -m vi-insert '"\C-r": "\C-z\C-r\C-z"'
else
  # CTRL-T - Paste the selected file path into the command line
  if [[ "${FZF_CTRL_T_COMMAND-x}" != "" ]]; then
    bind -m emacs-standard -x '"\C-t": fzf-file-widget'
    bind -m vi-command -x '"\C-t": fzf-file-widget'
    bind -m vi-insert -x '"\C-t": fzf-file-widget'
  fi

  # CTRL-R - Paste the selected command from history into the command line
  bind -m emacs-standard -x '"\C-r": __fzf_history__'
  bind -m vi-command -x '"\C-r": __fzf_history__'
  bind -m vi-insert -x '"\C-r": __fzf_history__'
fi

# ALT-C - cd into the selected directory
if [[ "${FZF_ALT_C_COMMAND-x}" != "" ]]; then
  bind -m emacs-standard '"\ec": " \C-b\C-k \C-u`__fzf_cd__`\e\C-e\er\C-m\C-y\C-h\e \C-y\ey\C-x\C-x\C-d"'
  bind -m vi-command '"\ec": "\C-z\ec\C-z"'
  bind -m vi-insert '"\ec": "\C-z\ec\C-z"'
fi

fi

PS1='[\W]:\$ '

