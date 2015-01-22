# Assign the DOTDIR path depending on hostname
DOTDIR=$([[ $(hostname -f) =~ ^wvandaalen(\.local)?$ ]] && 
    echo "$HOME/.wcvd-dotfiles" || echo "/tmp/.wcvd-dotfiles")

# Set VIMINIT variable so that we source the proper .vimrc file
VIMINIT='so $DOTDIR/vim/.vimrc | let $MYVIMRC = $DOTDIR . "vim/.vimrc"'


# Env settings
EDITOR=vim
TZ=America/New_York
LANG=en_US.UTF-8


################    Exports     ################

# 256 iTerm Colors
[[ "$TERM" == "xterm" ]] && export TERM=xterm-256color vim 

# export PATHs
export PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin"

# reduce the <ESC> timeout for use with vim mode
export KEYTIMEOUT=1

# export basic env settings
export EDITOR TZ LANG

# export DOTDIR so it can be used by vim
export DOTDIR

# export VIMINIT so that vim loads vundle it correctly
export VIMINIT

################    Includes    ################

# find in 'includes/' where name does not end in .swp
includes=( $(find $DOTDIR/zsh/includes -type f ! -iname "*.swp") )
for include in $includes; do
    . $include  
done


################    Bundles     ################

# load antigen
source ${DOTDIR}/zsh/antigen/antigen.zsh

# load oh-my-zsh bundles
antigen use oh-my-zsh
antigen theme wvandaal/steeef-theme steeef # set the prompt theme

# keep plugins in order to avoid conflicts
antigen bundles <<-Bundles
    
    z
    git
    sublime
    sharat87/zsh-vim-mode
    history-substring-search
    zsh-users/zsh-syntax-highlighting

    # tarruda/zsh-autosuggestions          # must be bundled last

Bundles


################   Initialize   ################

# Autosuggestions
# zle-line-init() { zle autosuggest-start }
# zle -N zle-line-init
# bindkey '^T' autosuggest-toggle  

# Add keybindings for history-substring-search so that it works with vi-mode
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down


# install all zsh bundles
antigen apply

# install vim plugins
vim +PluginInstall +qall!

