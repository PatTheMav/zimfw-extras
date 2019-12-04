if [ -z "$ZEXT_ALIAS" ]; then
    alias ducks="du -cks * | sort -rn| head -11"
    alias kindly="sudo"
    alias fucking="sudo"
    alias random="env LC_CTYPE=C LC_ALL=C tr -dc "a-zA-Z0-9-_\$\?" < /dev/urandom | head -c 24; echo"

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

    alias d='dirs -v | head -10'

    # Push and pop directories on directory stack
    alias pu='pushd'
    alias po='popd'

    if (( ${+commands[rsync]} )); then
        alias rsynccopy="rsync --partial --progress --append --rsh=ssh -r -h "
        alias rsyncmove="rsync --partial --progress --append --rsh=ssh -r -h --remove-sent-files"
    fi

    if (( ${+commands[openssl]} )); then
        alias sha1="openssl dgst -sha1"
        alias sha256="openssl dgst -sha256"
        alias sha512="openssl dgst -sha512"
    fi

    if (( ${+commands[curl]} )); then
        alias whatsmyip="curl -L https://ip.patthemav.com/"
    elif (( ${+commands[wget]} )); then
        alias whatsmyip="wget -q -O - https://ip.patthemav.com/"
    fi

    if (( ${+commands[youtube-dl]} )); then
        alias yt-dl="youtube-dl -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/mp4'"
    fi

    if (( ${+commands[git]} )); then
        alias grm="git ls-files --deleted -z | xargs -0 git rm"
    fi

    ZEXT_ALIAS="${ZEXT_ALIAS:-1}"
fi