function {
  emulate -L zsh

  local ztermtitle
  local ztabtitle

  if [[ "${TERM_PROGRAM}" == "Apple_Terminal" ]]; then
    zstyle -s ':zim:zimfw-extras' mactermtitle 'ztermtitle' || ztermtitle="%n@%15>..>%m%>>"
    zstyle -s ':zim:zimfw-extras' mactabtitle 'ztabtitle' || ztabtitle=""
  else
    zstyle -s ':zim:zimfw-extras' termtitle 'ztermtitle' || ztermtitle="%n@%15>..>%m%>>"
    zstyle -s ':zim:zimfw-extras' tabtitle 'ztabtitle' || ztabtitle="%15<..<%~%<<"
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
        fi
      fi
      ;;
  esac

  autoload -Uz add-zsh-hook && add-zsh-hook precmd termtitle_precmd
  termtitle_precmd

  # Apple Terminal can do this by itself, probably faster
  if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then
    termtitle_preexec() {
      emulate -L zsh
      setopt extended_glob

      local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
      local LINE="${2:gs/%/%%}"

      print -Pn '\e]1;${cmd:q}\a'; print -Pn '\e]2;${%100>...>${line}%<<:q}\a'
    }
    autoload -Uz add-zsh-hook && add-zsh-hook preexec termtitle_preexec
  fi
}

# Default aliases
alias ducks='du -cks * | sort -rn| head -11'
alias systail='tail -f /var/log/system.log'
alias fucking='sudo'
alias random='env LC_CTYPE=C LC_ALL=C tr -dc "a-zA-Z0-9-_\$\?" < /dev/urandom | head -c 24; echo'

if (( ${+commands[rsync]} )); then
    alias rsynccopy="rsync --partial --progress --append --rsh=ssh -r -h "
    alias rsyncmove="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"
fi

if (( ${+commands[openssl]} )); then
    alias sha1="openssl dgst -sha1"
    alias sha256="openssl dgst -sha256"
    alias sha512="openssl dgst -sha512"
fi

if (( ${+commands[colorsvn]} )); then
    alias svn="colorsvn"
fi

if (( ${+commands[curl]} )); then
    alias whatsmyip="curl -L https://ip.patthemav.com/"
fi

if (( ${+commands[youtube-dl]} )); then
    alias yt-dl="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"
fi

if (( ${+commands[git]} )); then
    alias grm="git ls-files --deleted -z | xargs -0 git rm"
fi

if (( ${+commands[gpg]} )); then
    alias gpgenc="env PINENTRY_USER_DATA="USE_CURSES=1" gpg -c"
    alias gpgdec="env PINENTRY_USER_DATA="USE_CURSES=1" gpg -d"
fi

setopt pushdminus
alias -- -='cd -'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

alias md='mkdir -p'
alias rd=rmdir
alias d='dirs -v | head -10'

# Push and pop directories on directory stack
alias pu='pushd'
alias po='popd'
export EDITOR='/usr/bin/vim'

case $OSTYPE in
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

[[ -s ${0:h}/token_extras.zsh ]] && source ${0:h}/token_extras.zsh

# export COLUMNS=160
export LESS="--RAW-CONTROL-CHARS"
export LESSHISTFILE=-