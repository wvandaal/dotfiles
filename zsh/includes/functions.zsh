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
	local DOTDIR=$([[ $(hostname -f) =~ ^wvandaalen(\.local)?$ ]] && 
		echo "$HOME/.wcvd-dotfiles" || echo "/tmp/.wcvd-dotfiles")

	# go to $DOTDIR, stash any git changes, checkout master, and pull
    cd $DOTDIR
    git reset --hard HEAD >/dev/null 2>&1
    git checkout master
    echo "Updating ${DOTDIR} from ${REPO}"
    git pull
    git submodule init
    git submodule update 

 	# if shell is zsh, source the dotfiles, else set the ZSHDOTDIR and open zsh 
 	# in interactive mode
    if [[ $($0) =~ zsh ]]; then
    	source $DOTDIR/zsh/.zshrc
    else
    	ZDOTDIR="${DOTDIR}/zsh/"
    	export ZDOTDIR
    fi

    # return to home dir
    cd
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

	local deploy=$(declare -f wdeploy)


}


function v_ssh() {

	local deploy="$(declare -f wdeploy)"
	local install="$(declare -f install_dotfiles)"
	local update="$(declare -f update_dotfiles)"
	local getzsh="$(declare -f setup_zsh)"
	local homebrew="$(declare -f install_homebrew)"

	vagrant ssh -- -A -t "$@" \
		"${homebrew} ;
		${getzsh} ;
		${update} ;
		${install} ;
		${deploy} ; 
		wdeploy;
		$(which zsh) -i;"

}
