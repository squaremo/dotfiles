if [[ -f $(which brew) && -d $(brew --prefix nvm) ]]; then
    source $(brew --prefix nvm)/nvm.sh;
fi
