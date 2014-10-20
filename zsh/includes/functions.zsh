#!/bin/zsh

################    Functions    ###############

# checks if zsh is installed and attempts to install it if not
function setup_zsh() {
	# if zsh is not installed
	if ! [[ -f $(which zsh) ]]; then

		echo "Zsh not found"
		echo "Attempting to install Zsh..."
		
		# if apt-get exists, use to install zsh
		if [[ -f $(which apt-get) ]]; then
			sudo apt-get install zsh

		elif [[ -f $(which yum) ]]; then
			sudo yum install zsh

		# if homebrew exists, use it to install zsh
		elif [[ -f $(which brew) ]]; then
			sudo brew install zsh

		# if homebrew is not installed and the machine uses OSX, 
		# install homebrew and then install zsh
		elif [[ $(uname) == Darwin ]]; then
			install_homebrew
			sudo brew install zsh
		else
			echo "Error: apt-get, yum, or homebrew required to install Zsh"
		fi
	fi
}

# function install_rsub() {
#     if [[ -f $(which wget) ]]; then
#         #statements
#     else
# }

# installs homebrew
function install_homebrew() {
	if [[ -f $(which ruby) ]]; then
		ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
	else
		echo "Error: Ruby is required to install Homebrew"
	fi
}

# installs dotfiles under the given $BASE directory
function install_dotfiles() {

	local REPO='https://github.com/wvandaal/dotfiles.git'
	local BASE=$([[ $(hostname -f) =~ ^wvandaalen(\.local)?$ ]] && echo $HOME || echo /tmp)

	echo "Cloning dotfiles to ${DOTDIR} from ${REPO}..."
	cd $BASE
	git clone ${REPO} .wcvd-dotfiles
	cd .wcvd-dotfiles
	git submodule update --init --recursive

	ZDOTDIR=${DOTDIR}/zsh
	export ZDOTDIR

	cd
}

# updates all dotfiles in the appropriate DOTDIR by pulling from the remote
# repository
function update_dotfiles(){

	local REPO='https://github.com/wvandaal/dotfiles'

	# go to $DOTDIR, stash any git changes, checkout master, and pull
    cd $DOTDIR
    git stash
    git reset --hard HEAD >/dev/null 2>&1
    git checkout master
    echo "Updating ${DOTDIR} from ${REPO}"
    git pull 
    git submodule init
    git submodule update

 	# if shell is zsh, source the dotfiles, else set the ZSHDOTDIR and open zsh 
 	# in interactive mode
    if [[ $(ps -o comm= -p $$) =~ zsh ]]; then
        echo "Reloading from updated .zshrc"
    	source $DOTDIR/zsh/.zshrc
    else
    	ZDOTDIR="${DOTDIR}/zsh/"
    	export ZDOTDIR
    fi


    # return to previous dir
    cd -
}


function wdeploy() {

    local DOTDIR=$([[ $(hostname -f) =~ ^wvandaalen(\.local)?$ ]] && 
        echo "$HOME/.wcvd-dotfiles" || echo "/tmp/.wcvd-dotfiles")

	setup_zsh
	
	# if the dotfiles directory exists, update from the remote
	# else install from the remote
	if [[ -d $DOTDIR ]]; then
        echo "${DOTDIR} already exists"
        printf "Update .wcvd-dotfiles from remote? "
        read RESP
        if [[ $RESP =~ ^[Yy]$ ]]; then
        	update_dotfiles
        else
        	ZDOTDIR="${DOTDIR}/zsh/"
        	export ZDOTDIR
        fi
	else
		echo "${DOTDIR} does not exist"
		install_dotfiles
	fi

}


# wrapper for ssh'ing into a remote machine and setting up dev
# environment
function wssh() {

	local deploy="$(declare -f wdeploy)"
	local install="$(declare -f install_dotfiles)"
	local update="$(declare -f update_dotfiles)"
	local getzsh="$(declare -f setup_zsh)"
	local homebrew="$(declare -f install_homebrew)"

	ssh -R 52698:localhost:52698 -A -t "$@" \
		"${homebrew} ;
		${getzsh} ;
		${update} ;
		${install} ;
		${deploy} ; 
		wdeploy;
		$(which zsh) -i;"
}


function vssh() {

	local deploy="$(declare -f wdeploy)"
	local install="$(declare -f install_dotfiles)"
	local update="$(declare -f update_dotfiles)"
	local getzsh="$(declare -f setup_zsh)"
	local homebrew="$(declare -f install_homebrew)"

    # login as root user and define all necessary functions for deploying dotfiles
	vagrant ssh -- -R 52698:localhost:52698 -l root -A -t "$@" \
		"${homebrew} ;
		${getzsh} ;
		${update} ;
		${install} ;
		${deploy} ; 
		wdeploy;
		$(which zsh) -i;"

}

# Aliasing for update and install functions
alias wupdate="update_dotfiles"
alias winstall="install_dotfiles"


# open file in the marked markdown app
function marked() {
  if [[ -d $1 ]]; then
    for f in *.md; do
      open -a marked.app $f
    done 
  elif [[ -f $1 ]]; then
    open -a marked.app $1
  else
    open -a marked.app
  fi
}

# fe [FUZZY PATTERN] - Open the selected file with the default editor
#   - Bypass fuzzy finder if there's only one match (--select-1)
#   - Exit if there's no match (--exit-0)
function fe() {
  local file
  file=$(fzf --query="$1" --select-1 --exit-0)
  [ -n "$file" ] && ${EDITOR:-vim} "$file"
}

# fd - cd to selected directory
function fd() {
  local dir
  dir=$(find ${1:-*} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}
