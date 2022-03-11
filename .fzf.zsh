# Setup fzf
# ---------
if [[ ! "$PATH" == */home/eddy/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/eddy/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/eddy/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/eddy/.fzf/shell/key-bindings.zsh"
