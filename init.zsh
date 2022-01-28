function {
  emulate -L zsh

  local ztermtitle
  local ztabtitle

  if [[ "${TERM_PROGRAM}" == "Apple_Terminal" ]]; then
    ztermtitle="%n@%15>..>%m%>>"
    ztabtitle=""
  else
    zstyle -s ':zim:termtitle' format 'ztermtitle' || ztermtitle="%n@%15>..>%m%>>"
    zstyle -s ':zim:tabtitle' format 'ztabtitle' || ztabtitle="%15<..<%~%<<"
  fi

  case "${TERM}" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      eval "termtitle_precmd() { print -Pn '\e]1;${ztabtitle:q}\a'; print -Pn '\e]2;${ztermtitle:q}\a' }"
      ;;
    screen*)
      eval "termtitle_precmd() { print -Pn '\ek${ztabtitle:q}\e\\' }"
      ;;
    *)
      if [[ "${TERM_PROGRAM}" == "iTerm.app" ]]; then
        eval "termtitle_precmd() { print -Pn '\e]1;${ztabtitle:q}\a' print -Pn '\e]2;${ztermtitle:q}\a' }"
      else
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
          eval "termtitle_precmd() { echoti tsl; print -Pn '${ztabtitle}'; echoti fsl' }"
        else
          eval "termtitle_precmd() {}"
        fi
      fi
      ;;
  esac

  autoload -Uz add-zsh-hook && add-zsh-hook precmd termtitle_precmd
  termtitle_precmd

  # Apple Terminal can do this by itself, probably faster
  if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]] && [[ -z "${SSH_CONNECTION} " ]]; then
    termtitle_preexec() {
      emulate -L zsh
      setopt extended_glob

      local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
      local LINE="${2:gs/%/%%}"

      print -Pn '\e]1;${cmd:q}\a'; print -Pn '\e]2;${%100>...>${line}%<<:q}\a'
    }
    autoload -Uz add-zsh-hook && add-zsh-hook preexec termtitle_preexec
  fi

  local _mode
  read _ _ _mode _ <<< "$(bindkey -lL main)"

  if [[ "${_mode}" == "viins" ]]; then
    function _vi-mode-cursor {
      case "${KEYMAP}" in
        main | viins | isearch | command) print -n $'\e[5 q' ;;
        vicmd | visual) print -n $'\e[0 q' ;;
        viopp) print -n $'\e[4 q' ;;
        *) print -n $'\e[0 q' ;;
      esac
    }

    function zle-line-init {
      _vi-mode-cursor
    }

    function zle-keymap-select {
      _vi-mode-cursor
    }

    zle -N zle-line-init
    zle -N zle-keymap-select
  fi
}

export EDITOR="$(command -v vim)"
export LESS="--RAW-CONTROL-CHARS"
export LESSHISTFILE=-

case "${OSTYPE}" in
    darwin*)
        [[ -s ${0:h}/macos_extras.zsh ]] && source ${0:h}/macos_extras.zsh
        ;;
    linux*)
        [[ -s ${0:h}/linux_extras.zsh ]] && source ${0:h}/linux_extras.zsh
        ;;
    msys*|mingw*|cygwin*)
        [[ -s ${0:h}/windows_extras.zsh ]] && source ${0:h}/windows_extras.zsh
        ;;
    'AIX')     [[ "$TERM" == "" ]] && export TERM='aixterm' ;;
    * )        [[ "$TERM" == "" ]] && export TERM='vt100' ;;
esac

[[ -s ${0:h}/aliases.zsh ]] && source ${0:h}/aliases.zsh
[[ -s ${0:h}/tokens.zsh ]] && source ${0:h}/tokens.zsh
