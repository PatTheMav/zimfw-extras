if [[ -z "$ZEXT_OS" ]]; then
    export HOMEBREW_INSTALL_BADGE="🖥 "

    if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]] && ! typeset -f update_terminal_cwd > /dev/null; then
        urlencode() {
            emulate -L zsh
            setopt localoptions extendedglob

            input=( ${(s::)1} )
            print "${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}"
        }

        termtitle_macos() {
            local pwd_enc=$(urlencode "$(pwd)")
            printf '\e]7;%s\a' "file://${HOST}${pwd_enc}"
        }

        autoload -Uz add-zsh-hook && add-zsh-hook precmd termtitle_macos
        termtitle_macos
    fi

    alias ps2='ps -facx '
    alias ps1='ps -faxo "user etime pid args" '
    alias af='ps -af'
    alias top='top -o cpu'
    alias listeners='sudo lsof -iTCP -sTCP:LISTEN'

    ZEXT_OS="${ZEXT_OS:-1}"
fi
