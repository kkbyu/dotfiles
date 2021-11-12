# homebrew-bundle
brew bundle --file ~/Brewfile

# nvm
if [ -e "$HOME/.nvm" ]; then
  # install nvm
  echo "install nvm"
  export NVM_DIR="$HOME/.nvm" && (
  git clone https://github.com/nvm-sh/nvm.git "$NVM_DIR"
  cd "$NVM_DIR"
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  ) && \. "$NVM_DIR/nvm.sh"
else
  # update nvm
  (
  echo "update nvm"
  cd "$NVM_DIR"
  git fetch --tags origin
  git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
  ) &&  \. "$NVM_DIR/nvm.sh"
fi
