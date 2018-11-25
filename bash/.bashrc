#!/usr/bin/env bash

# Environment Variables
PROMPT_STYLE=extensive


HISTCONTROL=ignorespace:ignoredups

# y	year in 2-digit format
# Y	year in 4-digit format
# m	month in 2-digit format
# d	day in 2-digit format
# T	time in 24-hour format
# %r	date in 12 hour AM/PM format
# %D	date in mm/dd/yy format
HISTTIMEFORMAT="%d-%m-%Y (%T/%r) "
HISTSIZE=1000
HISTFILESIZE=20000

# Source jm-shell custom prompt if it exists.
if [ -f "$HOME/.bash-config/jm-shell/ps1" ];then

    # shellcheck disable=1090
    source "$HOME/.bash-config/jm-shell/ps1"
fi

# Welcome Message
if [ -x "$(command -v sl)" ];then
    sl -a
    clear
    # brew install cowsay
    if [ -x "$(command -v cowthink)" ];then
        if [ -x "$(command -v fortune)" ];then
           expressions=(
                        "dragon-and-cow"
                        "kiss"
                        "beavis.zen"
                        "blowfish"
                        "bong"
                        "bud-frogs"
                        "bunny"
                        "cheese"
                        "cower"
                        "daemon"
                        "default"
                        "dragon"
                        "elephant"
                        "elephant-in-snake"
                        "eyes"
                        "flaming-sheep"
                        "ghostbusters"
                        "head-in"
                        "hellokitty"
                        "kitty"
                        "koala"
                        "kosh"
                        "luke-koala"
                        "meow"
                        "milk"
                        "moofasa"
                        "moose"
                        "mutilated"
                        "ren"
                        "satanic"
                        "sheep"
                        "skeleton"
                        "small"
                        "sodomized"
                        "stegosaurus"
                        "stimpy"
                        "supermilker"
                        "surgery"
                        "telebears"
                        "telebears"
                        "three-eyes"
                        "turkey"
                        "turtle"
                        "tux"
                        "udder"
                        "vader"
                        "vader-koala"
                        "www"
                    )
             RANDOM=$$$(date +%s)
             selectedexpression=${expressions[$RANDOM % ${#expressions[@]}]}
             fortune -s | cowthink -f $selectedexpression
        fi
    fi
fi



### Get os name via uname ###
_myos="$(uname)"
    echo "******    Operting System:    $_myos	*******"
case $_myos in
   Darwin)
if [ -f "$HOME/.bash-config/bash/.bash_aliases_mac" ];then
    # shellcheck disable=1090
    source "$HOME/.bash-config/bash/.bash_aliases_mac"
fi
   ;;
   Linux)
if [ -f "$HOME/.bash-config/bash/.bash_aliases_linux" ];then
    source "$HOME/.bash-config/bash/.bash_aliases_linux"
fi
   ;;
   *) ;;
esac


# ---- GIT ----
git config --global color.ui true
git config --global include.path ~/.bash-config/git/.gitalias
git config --global help.autocorrect 1
git config --global core.excludesFile ~/.bash-config/git/.gitignore
git config --global core.attributesFile ~/.bash-config/git/.gitattributes
git config --global commit.template ~/.bash-config/git/.gitmessage

## Directory Bookmark Manager ##
source "$HOME/.bash-config/bashmarks/bashmarks.sh"

