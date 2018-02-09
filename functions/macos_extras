if [ -z "$ZEXT_OS" ]; then
    if [[ "$TERM_PROGRAM" == "Apple_Terminal" ]] && [[ -z "$INSIDE_EMACS" ]]; then
      function update_terminalapp_cwd() {
        local URL_PATH=''
        {
            # Use LC_CTYPE=C to process text byte-by-byte. Ensure that
            # LC_ALL isn't set, so it doesn't interfere.
            local i ch hexch LC_CTYPE=C LC_ALL=
            for ((i = 0; i < ${#PWD}; ++i)); do
                ch="${PWD:$i:1}"
                if [[ "$ch" =~ [/._~A-Za-z0-9-] ]]; then
                    URL_PATH+="$ch"
                else
                    printf -v hexch "%02X" "'$ch"
                    # printf treats values greater than 127 as
                    # negative and pads with "FF", so truncate.
                    URL_PATH+="%${hexch: -2:2}"
                fi
            done
        }
        printf '\e]7;%s\a' "file://$HOST$URL_PATH"
      }

      # Use a precmd hook instead of a chpwd hook to avoid contaminating output
      precmd_functions+=(update_terminalapp_cwd)
      # Run once to get initial cwd set
      update_terminalapp_cwd
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