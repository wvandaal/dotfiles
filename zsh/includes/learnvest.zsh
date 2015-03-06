#!/bin/zsh

export EMAIL_REPO=$HOME/git/email
source $EMAIL_REPO/bash

function email {
    if [ "$1" == "mkdir" ]; then
        for dir in $EMAIL_REPO/templates $EMAIL_REPO/vars/test $EMAIL_REPO/cdn; do
            mkdir -p -v $dir/$2
        done
    fi
}
