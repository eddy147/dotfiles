source ~/.bashrc

if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then
    GIT_PROMPT_ONLY_IN_REPO=1
    source $HOME/.bash-git-prompt/gitprompt.sh
fi

function _mix_hex_latest() {
    mix hex.info $1 | grep 'Config:' | sed 's/.*{\(.*\)}[^}]*/{\1},/'
}

alias mix_hex_latest='_mix_hex_latest'
