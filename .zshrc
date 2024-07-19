eval "$(termium shell-hook show pre)"
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

export PATH=$HOME/bin:/usr/local/bin:$HOME/.fzf/bin:$HOME/.asdf/bin:$HOME/.asdf/shims:$PATH
export PATH=$PATH:$HOME/elixir-ls/language_server.sh
export PATH=$PATH:$HOME/.cargo/bin

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="agnoster-light"
#ZSH_THEME='steeef'
#ZSH_THEME='robbyrussell'
#

## Uncomment the following line to enable command auto-correction.
ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
. /home/eddy/.asdf/asdf.sh
export PATH=~/.asdf/shims:$PATH
export PATH=~/tools/DataGrip/bin:$PATH

source ~/.aliases
source ~/.aliases-kubernetes

# Access to AWS SSM, see https://github.com/driveulu/handbook/blob/main/README.md#access-1

# export AWS_PROFILE=ulu_ops_eddydeboer
# ACCOUNT_ID='766107116595'
# ROLE_NAME='developer'
# export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s xAWS_SESSION_TOKEN_EXPIRATION=%s" $(aws sts assume-role --duration-seconds 1800 --role-arn "arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}" --role-session-name abc --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken,Expiration]" --output text))

ROLE_NAME='developer'

AWS_PROD_ID='771781624322'
AWS_STAG_ID='766107116595'

aws_mode() {
        usage() {
                echo "Usage: aws_mode [prod|stag]"
        }

        if [ -z "$1" ]; then
                usage
                return
        fi

        unset AWS_ACCESS_KEY_ID
        unset AWS_SECRET_ACCESS_KEY
        unset AWS_SESSION_TOKEN

        echo "PROD_ID=${AWS_PROD_ID}"
        echo "STAG_ID=${AWS_STAG_ID}"

        if [[ "$1" == "prod" ]]; then
                echo "prod mode"
                export ACCOUNT_ID=$AWS_PROD_ID
        elif [[ "$1" == "stag" ]]; then
                export ACCOUNT_ID=$AWS_STAG_ID
        else
                usage
                return
        fi

        export $(printf "AWS_ACCESS_KEY_ID=%s AWS_SECRET_ACCESS_KEY=%s AWS_SESSION_TOKEN=%s xAWS_SESSION_TOKEN_EXPIRATION=%s" $(aws sts assume-role --duration-seconds 1800 --role-arn "arn:aws:iam::${ACCOUNT_ID}:role/${ROLE_NAME}" --role-session-name abc --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken,Expiration]" --output text))
        echo "Assuming role $ROLE_NAME in account $1 : $ACCOUNT_ID"
}

aws_ssm() {
        local ec2_name=$1
        INSTANCE_ID=$(aws ec2 describe-instances \
                --filter "Name=tag:Name,Values=${ec2_name}" \
                --query "Reservations[].Instances[?State.Name == 'running'].InstanceId[]" \
                --output text)
        aws ssm start-session --target $INSTANCE_ID
}

aws_instances() {
        aws ec2 describe-instances --query 'Reservations[*].Instances[*].{Instance:InstanceId,State:State.Name,Name:Tags[?Key==`Name`]|[0].Value}' --output table
}

start_staging() {
        aws_mode stag && \
        aws lambda invoke --function-name eks_staging_autoscaling --region eu-west-1 /tmp/bla.json
}

export PATH="/home/eddy/.krew/bin:/home/eddy/tools/DataGrip/bin:/home/eddy/.asdf/shims:/home/eddy/.asdf/shims:/home/eddy/.asdf/bin:/home/eddy/bin:/usr/local/bin:/home/eddy/.fzf/bin:/home/eddy/tools/DataGrip/bin:/home/eddy/bin:/usr/local/bin:/home/eddy/.fzf/bin:/home/eddy/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/snap/bin:/home/eddy/.local/share/JetBrains/Toolbox/scripts:/home/eddy/elixir-ls/release:/home/eddy/.cargo/bin:/home/eddy/.krew/bin:/home/eddy/elixir-ls/release:/home/eddy/.cargo/bin"

export BUILDKIT_PROGRESS=plain

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
