if [[ -z "$ZEXT_OS" ]]; then
    export HOMEBREW_INSTALL_BADGE="💾 "

    if (( ${+commands[bat]} )) {
      export MANPAGER="sh -c 'sed -u -e \"s/\\x1B\[[0-9;]*m//g; s/.\\x08//g\" | bat -l man -p --pager=\"less -s -M +Gg\"'"
      export MANROFFOPT="-c"
    } else {
      export MANPAGER='less -s -M +Gg'
    }

    ZEXT_OS="${ZEXT_OS:-1}"
fi

