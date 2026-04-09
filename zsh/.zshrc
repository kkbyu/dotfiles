autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

fpath=(/path/to/homebrew/share/zsh-completions $fpath)
PS1="[${USER}]%(!.#.$) "

autoload -U compinit
compinit -u


export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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
alias python='python3'

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
# ssh & tmux
alias ss='cd ~/.ssh && tmux'

# git command
_gst_index_file() {
  echo "${TMPDIR:-/tmp}/gst-index-${UID}-${$}"
}

gst () {
  local index_file
  index_file="$(_gst_index_file)"

  git -c color.status=always status -b --short -uall | perl -pe 'BEGIN { $n = 0 } if ($. > 1) { s/^/sprintf("%2d ", ++$n)/e }'
  git status --short -uall | awk '{ print substr($0, 4) }' >! "$index_file"
  git stash list
}

rm () {
  if [ $# -eq 1 ] && [[ "$1" =~ ^[0-9]+$ ]]; then
    local index_file target
    index_file="$(_gst_index_file)"

    if [ ! -f "$index_file" ]; then
      echo "rm: gst を先に実行してください" >&2
      return 1
    fi

    target=$(awk "NR==$1" "$index_file")
    if [ -z "$target" ]; then
      echo "rm: 番号 $1 は見つかりません" >&2
      return 1
    fi

    command rm -- "$target"
    return $?
  fi

  command rm "$@"
}

alias gbd='git branch --merged|egrep -v "\*|develop|master"|xargs git branch -d'
alias ghc='gh pr create --fill'
alias ghm='gh pr merge --merge'
alias ghcm='ghc && ghm'
alias ｇｓｔ='gst'
alias ｇか='gca'
alias ｇｃｍ='gcm'

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

if [ "$(uname -m)" = "arm64" ]; then
#  source /opt/homebrew/Cellar/asdf/0.14.0/libexec/asdf.sh
  source $(brew --prefix asdf)/libexec/asdf.sh
else
  source /usr/local/opt/asdf/libexec/asdf.sh
fi

# laradockのworkspace に入る
alias dws='docker exec --user=laradock -it $(docker ps --format "{{.Names}}" | grep workspace | head -n 1) /bin/bash'

#create project (github) & open IntelliJ
create_p (){
      if [ $# -eq 1 ]; then
          repo_name="$1"
          gh repo create "$repo_name" --private -d "$repo_name" --add-readme
          git clone git@github.com:kkbyu/$repo_name.git 
          idea "$repo_name"
      else
          echo "Usage: create_p <repository_name>"
          exit 1
      fi
}
# 上記の改良版
ghidea () {
  if [ $# -ne 1 ]; then
    echo "Usage: ghidea <repository_name>"
    return 1
  fi

  repo_name="$1"

  if [[ ! "$repo_name" =~ ^[a-zA-Z0-9._-]+$ ]]; then
    echo "❌ Invalid repository name: $repo_name"
    return 2
  fi

  if [ -d "$repo_name" ]; then
    echo "⚠️ Directory '$repo_name' already exists. Aborting."
    return 3
  fi

  user=$(gh api user --jq .login 2>/dev/null)
  if [ -z "$user" ]; then
    echo "❌ Failed to get GitHub username."
    return 4
  fi

  if ! gh repo create "$repo_name" --private -d "$repo_name" --add-readme; then
    echo "❌ Failed to create GitHub repository."
    return 5
  fi

  if ! git clone "git@github.com:${user}/${repo_name}.git"; then
    echo "❌ Failed to clone repository."
    return 6
  fi

  if ! idea "$repo_name"; then
    echo "❌ Failed to open project in IntelliJ IDEA."
    return 7
  fi

  echo "✅ Project '$repo_name' created and opened in IntelliJ IDEA!"
}


alias ghv='gh repo view --web'

. "/Users/kkb/.deno/env"

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Added by Antigravity
export PATH="/Users/kkb/.antigravity/antigravity/bin:$PATH"
