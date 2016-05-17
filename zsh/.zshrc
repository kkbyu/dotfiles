autoload -Uz VCS_INFO_get_data_git; VCS_INFO_get_data_git 2> /dev/null

fpath=(/path/to/homebrew/share/zsh-completions $fpath)

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

alias gst='git status -s -b && git stash list'
gcm () { git commit -m "$*" }

alias ls='ls -Gla'
alias glgg='git log --stat --pretty=format:'%Cblue%h %Cgreen%ar %Cred%an %Creset%s %Cred%d''

#scala path
export PATH=$PATH:/usr/local/src/scala/bin
export SCALA_HOME=/usr/local/src/scala

#brew etc
export PATH=$PATH:/usr/local/bin

#android sdk
export ANDROID_HOME=/usr/local/opt/android-sdk

#Kobito
alias kobito="open -a Kobito"

#npm
if [ -d ${HOME}/node_modules/.bin ]; then
    export PATH=${PATH}:${HOME}/node_modules/.bin
fi

