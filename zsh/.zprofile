if [ "$(uname -m)" = "arm64" ]; then
    # m
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    # intel
    eval "$(/usr/local/bin/brew shellenv)"
fi

