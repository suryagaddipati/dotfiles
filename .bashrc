source ~/.bash_profile
export DISPLAY_MAC=`ifconfig en0 | grep "inet " | cut -d " " -f2`:0
eval "$(starship init bash)"
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
eval "$(pyenv init -)"

