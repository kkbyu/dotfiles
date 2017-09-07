####
#
# PATH
#
####

#scala path
export PATH=$PATH:/usr/local/src/scala/bin
export SCALA_HOME=/usr/local/src/scala

#activator path
export PATH=$PATH:/usr/local/activator-1.3.10-minimal/bin

#brew etc
export PATH=$PATH:/usr/local/bin

#android sdk
export ANDROID_HOME=/usr/local/opt/android-sdk

#npm
if [ -d ${HOME}/node_modules/.bin ]; then
    export PATH=${PATH}:${HOME}/node_modules/.bin
fi

#nvm
export NVM_DIR="$HOME/.nvm"
source "/usr/local/opt/nvm/nvm.sh"

#Python
export PYENV_ROOT="${HOME}/.pyenv"
export PATH="${PYENV_ROOT}/bin:$PATH"
eval "$(pyenv init -)"

#PHP7
export PATH="$(brew --prefix homebrew/php/php70)/bin:$PATH"


#open alias
#Kobito
alias kobito="open -a Kobito"


