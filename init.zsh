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
    'AIX')     export TERM='aixterm' ;;
    * )        export TERM='vt100' ;;
esac

[[ -s ${0:h}/token_extras.zsh ]] && source ${0:h}/token_extras.zsh

# export COLUMNS=160
export LESS="--RAW-CONTROL-CHARS"
export LESSHISTFILE=-

if ! (($+ZSH_TERM_TITLE)); then
  if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
    ZSH_TERM_TAB=""
    ZSH_TERM_TITLE="%n@%m%15>..>%>>"
  else
    ZSH_TERM_TAB="%15<..<%~%<<"
    ZSH_TERM_TITLE="%n@%m: %~"
  fi
fi

function title {
  [[ "$EMACS" == *term* ]] && return
  : ${2=$1}

  case "$TERM" in
    cygwin|xterm*|putty*|rxvt*|ansi)
      print -Pn "\e]2;$2:q\a" # set window name
      if [[ "$TERM_PROGRAM" != "Apple_Terminal" ]]; then # || [[ "$TERM_PROGRAM_VERSION" =~ "38.*" ]]; then
        print -Pn "\e]1;$1:q\a" # set tab name
      fi
      ;;
    screen*)
      print -Pn "\ek$1:q\e\\" # set screen hardstatus
      ;;
    *)
      if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
        print -Pn "\e]2;$2:q\a" # set window name
        print -Pn "\e]1;$1:q\a" # set tab name
      else
        # Try to use terminfo to set the title
        # If the feature is available set title
        if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
          echoti tsl
          print -Pn "$1"
          echoti fsl
        fi
      fi
      ;;
  esac
}

function termsupport_precmd {
  if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
    return
  fi

  title $ZSH_TERM_TAB $ZSH_TERM_TITLE
}

# Runs before executing the command
function termsupport_preexec {
  if [[ "$DISABLE_AUTO_TITLE" == true ]]; then
    return
  fi

  # cmd name only, or if this is sudo or ssh, the next cmd
  local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
  local LINE="${2:gs/%/%%}"

  title '$CMD' '%100>...>$LINE%<<'
}

precmd_functions+=(termsupport_precmd)
# Apple Terminal can do this by itself, probably faster
if ! [[ "$TERM_PROGRAM" == "Apple_Terminal" ]]; then
  preexec_functions+=(termsupport_preexec)
fi
