[[ -f ~/.base16_theme ]] && source ~/.base16_theme

if (( ${+BASE16_THEME} )) {
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=18,fg=16,bold"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=18"
    #typeset -A ZSH_HIGHLIGHT_STYLES
    #ZSH_HIGHLIGHT_STYLES[comment]='fg=18'
    export BAT_THEME='base16-256'
} else {
    HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND="bg=10,fg=9,bold"
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=10"
    #typeset -A ZSH_HIGHLIGHT_STYLES
    #ZSH_HIGHLIGHT_STYLES[comment]='fg=10'
    export BAT_THEME='base16'
}

export LESS_TERMCAP_mb=$'\e[1;31m'          # Begins blinking.
export LESS_TERMCAP_md=$'\e[1;31m'          # Begins bold.
export LESS_TERMCAP_me=$'\e[0m'             # Ends mode.
export LESS_TERMCAP_se=$'\e[0m'             # Ends standout-mode.
export LESS_TERMCAP_so=$'\e[44;33;1m'       # Begins standout-mode.
export LESS_TERMCAP_ue=$'\e[0m'             # Ends underline.
export LESS_TERMCAP_us=$'\e[01;32m'         # Begins underline.

export GREP_COLOR='01;91'
export GREP_COLORS='sl=48;5;236;97:cx=40;37:mt=49;38;5;215;1:fn=49;38;5;203:ln=49;38;5;114:bn=49;38;5;176:se=49;38;5;68'
