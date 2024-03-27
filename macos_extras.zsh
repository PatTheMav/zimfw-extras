if [[ -z "$ZEXT_OS" ]]; then
    export HOMEBREW_INSTALL_BADGE="💻 "

    if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]] {
        termtitle_macos() {
            setopt localoptions extendedglob

            local -a input=(${(s::)${PWD}})
            local pwd_encoded="${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}"

            printf '\e]7;%s\a' "file://${HOST}${pwd_encoded}"
        }

        autoload -Uz add-zsh-hook

        add-zsh-hook precmd termtitle_macos

        if typeset -f update_terminal_cwd > /dev/null; then
            add-zsh-hook -d precmd update_terminal_cwd
            unfunction update_terminal_cwd
        fi

        termtitle_macos
    }

    alias ps2='ps -facx '
    alias ps1='ps -faxo "user etime pid args" '
    alias af='ps -af'
    alias top='top -o cpu'
    alias listeners='sudo lsof -iTCP -sTCP:LISTEN'

    ZEXT_OS="${ZEXT_OS:-1}"
fi
