if [ -z "$ZEXT_OS" ]; then
    if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then
        urlencode() {
            emulate -L zsh
            setopt localoptions extendedglob

            input=( ${(s::)1} )
            print "${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}"
        }

        termtitle_macos() {
            printf '\e]7;%s\a' "$(urlencode $(pwd))"
        }

        autoload -Uz add-zsh-hook && add-zsh-hook precmd termtitle_macos
        termtitle_macos
    fi

    alias ps2='ps -facx '
    alias ps1='ps -faxo "user etime pid args" '
    alias af='ps -af'
    alias top='top -o cpu'
    alias listeners='sudo lsof -iTCP -sTCP:LISTEN'
    alias flushdns='sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
    alias flushdownloads="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"
    alias listdownloads="sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'select LSQuarantineDataURLString from LSQuarantineEvent' | sort"

    if (( ${+commands[brew]} )); then
        export HOMEBREW_INSTALL_BADGE="🖥 "
        export EDITOR='/usr/local/bin/vim'

        alias remux='gfind . -type f -name "*.mp4" -print0 | gxargs -r -0 -n2 -i ffmpeg -i {} -vcodec copy -acodec copy "../{}"'
    fi

    ZEXT_OS="${ZEXT_OS:-1}"
fi