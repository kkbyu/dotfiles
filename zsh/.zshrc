autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

fpath=(/path/to/homebrew/share/zsh-completions $fpath)
PS1="[${USER}]%(!.#.$) "

autoload -U compinit
compinit -u

function rprompt-git-current-branch {
        local name st color gitdir action
        if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
                return
        fi

        name=`git rev-parse --abbrev-ref=loose HEAD 2> /dev/null`
        if [[ -z $name ]]; then
                return
        fi

        gitdir=`git rev-parse --git-dir 2> /dev/null`
        action=`VCS_INFO_git_getaction "$gitdir"` && action="($action)"

	if [[ -e "$gitdir/rprompt-nostatus" ]]; then
		echo "$name$action "
		return
	fi

        st=`git status 2> /dev/null`
	if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
		color=%F{green}
	elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
		color=%F{yellow}
	elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
                color=%B%F{red}
        else
                color=%F{red}
        fi

        echo "$color$name$action%f%b "
}

# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
setopt prompt_subst

RPROMPT='[`rprompt-git-current-branch`%~]'

# alias
alias ll='ls -lh'
alias ..="cd .."

# mkdir + cd
function mc() {
    mkdir -p "$@" && cd "$@"
}
# open tmp
alias ot='open ~/tmp'
# idea
function idea() {
    open -na "IntelliJ IDEA.app" --args "$@"
}

# git command
alias gst='git status -s -b -uall && git stash list'
alias gbd='git branch --merged|egrep -v "\*|develop|master"|xargs git branch -d'
gcm () { git commit -m "$*" }

gca () { aicommits --generate 5 }

gsta (){
      if [ $# -eq 1 ]; then
          git add `git status -s -b | grep -v "^#" | awk '{print$1="";print}' | grep -v "^$" | awk "NR==$1"`
      else
          exit 1
      fi
}

gstd (){
      if [ $# -eq 1 ]; then
          git diff -- `git status -s -b | grep -v "^#" | awk '{print$1="";print}' | grep -v "^$" | awk "NR==$1"`
      else
          exit 1
      fi
}

alias glgg="git log --stat --pretty=format:'%Cblue%h %Cgreen%ar %Cred%an %Creset%s %Cred%d'"

alias glggg="git log --graph --date-order --pretty=format:'%Cblue%h %Cgreen%ci %Cred%an %Cblue%m %Creset%s %Cred%d'"

#ls
case "${OSTYPE}" in
  darwin*)
    # Mac
    alias ls="ls -laGF"
      ;;
  linux*)
    # Linux
    alias ls='ls -Fla --color'
      ;;
esac

#history
alias his='history'

#peco
function peco-history-selection() {
        BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
        CURSOR=$#BUFFER
        zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}

function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^x' peco-cdr

#share_history
setopt share_history
setopt hist_no_store
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

#コマンドラインでコメントを有効
setopt interactivecomments

#docker
alias dps='docker ps'
alias dp='docker ps'
alias dsa='docker stop $(docker ps -q);docker ps'

# asdf & brew 
# switch m1 / intel

alias af='asdf'
#source /opt/homebrew/opt/asdf/asdf.sh
source /opt/homebrew/opt/asdf/libexec/asdf.sh

#if [ "$(uname -m)" = "arm64" ]; then
#  source /opt/homebrew/opt/asdf/asdf.sh
#  eval "$(/opt/homebrew/bin/brew shellenv)"
#else
# source /usr/local/Cellar/asdf/0.9.0/asdf.sh
#  eval "$(/usr/local/bin/brew shellenv)"
#fi

#create project (github) & open IntelliJ
create_p (){
      if [ $# -eq 1 ]; then
          repo_name="$1"
          gh repo create "$repo_name" --private -d "$repo_name"
          git clone git@github.com:kkbyu/$repo_name.git 
          idea "$repo_name"
      else
          echo "Usage: create_p <repository_name>"
          exit 1
      fi
}

alias ghv='gh repo view --web'

