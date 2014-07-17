# Homebrew stuffs go here:

if [ -f $(which brew) ]; then
    export PATH=$(brew --prefix)/bin:$(brew --prefix)/sbin:$PATH

    if [ -f $(brew --prefix)/etc/bash_completion ]; then
        . $(brew --prefix)/etc/bash_completion
    fi

    # Put Homebrew-ruby gems on the path
    export PATH=$(brew --prefix ruby)/bin:$PATH
fi
