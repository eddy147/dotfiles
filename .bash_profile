source ~/.bashrc

# git clone https://github.com/darkwebdesign/advanced-ps1.git ~/.advanced-ps1

# Configure advanced PS1.
export ADVANCED_PS1_SHOWNEWLINE=1;
export ADVANCED_PS1_SHOW0EXITCODE=0;
export ADVANCED_PS1_SHOWEXITCODEMESSAGE=0;
export ADVANCED_PS1_SHOW0DURATION=0;
export ADVANCED_PS1_SHOWTIME12H=0;

# Source advanced PS1.
source "${HOME}/.advanced-ps1/advanced-ps1";

# Enable advanced PS1 duration measurement.
trap '__advanced_ps1_debug_trap' DEBUG;

# Enable advanced PS1.
PROMPT_COMMAND='__advanced_ps1';
