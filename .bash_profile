source ~/.bashrc

source ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=true      # staged '+', unstaged '*'
export GIT_PS1_SHOWUNTRACKEDFILES=true  # '%' untracked files
export GIT_PS1_SHOWUPSTREAM="auto"      # '<' behind, '>' ahead, '<>' diverged, '=' no difference
export GIT_PS1_SHOWSTASHSTATE=true      # '$' something is stashed

function __prompt_command() {
    local ERRORCODE="$?"
    PS1="${debian_chroot:+($debian_chroot)}"

    # Errorcode (conditional)
    if [ ${ERRORCODE} != 0 ]; then
        PS1+="\e[90m    $(echo -e '\u2570\u2500\u2770')\e[1;31m$ERRORCODE\e[90m$(echo -e '\u2771')\e[0m\n"
    fi

    # Main line
    local c="$(echo -e '\u256d\u2500')"
    if [[ "$(dirs -p | wc -l)" != "1" ]] ; then
        local c="$(echo -e '\u2934') "
    fi
    PS1+="\e[90m$c\e[0m"
    if [[ ! -z "${VIRTUAL_ENV}" ]]; then
        PS1+="\e[90m$(echo -e '\u2770')\e[32m$(basename $VIRTUAL_ENV)\e[90m$(echo -e '\u2771')\e[0m"
    fi
    PS1+=" \e[33;1m\w\e[m"
    PS1+="\$(__git_ps1)"

    # Command Line
    PS1+="\n\e[90m$(echo -e '\u2570\u2500\u2bc8') \e[0m"
}

export PROMPT_COMMAND=__prompt_command
