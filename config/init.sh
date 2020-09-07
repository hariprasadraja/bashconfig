#!/usr/bin/env bash

#=================================================================================
#title           :defaults.sh
#description     :This script contains default aliases and configurations independent of operating system.
#                 These configurations may overwrite the os specific configurations declared inside config/os/ directory.
#                 please make sure, the default configuration is not overwrittern.
#author		 	 :hariprasad <hariprasadcsmails@gmail.com>
#version         :1.0
#usage		 	 :source /path/to/script/defaults/sh
#bash_version    :bash 4.3.48
#==================================================================================

# Add alias if 'code' cmd exist.
if [ -x "$(command -v code)" ]; then
    alias code='code -n --max-memory 4096'
    alias diff='code -n -d'
fi

alias ..='cd ..'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..'
alias ~="cd ~"

alias bc='bc -l'
alias sha1='openssl sha1'
alias h='history'
alias j='jobs -l'

now() {
    echo -e "TODAY: $(date +"%d-%m-%Y")"
    echo -e "$(date +"(24-hrs: %T  | 12-hrs: %r)")"
    echo -e "$(date -u +"(24-hrs: %T | 12-hrs: %r)")"
}

# Stop after sending count ECHO_REQUEST packets #
alias ping='ping -c 5'

# Do not wait interval 1 second, go fast
alias fastping='ping -c 100 -s.2'

## shortcut for iptables and pass it via sudo
if [ $(command -v $(which iptables)) ]; then
    alias ipt='sudo $(which iptables)' # display all rules #
    alias iptlist='sudo $(which iptables) -L -n -v --line-numbers'
    alias iptlistin='sudo $(which iptables) -L INPUT -n -v --line-numbers'
    alias iptlistout='sudo $(which iptables) -L OUTPUT -n -v --line-numbers'
    alias iptlistfw='sudo $(which iptables) -L FORWARD -n -v --line-numbers'
fi

# show all opened ports
alias ports='netstat -tulanp'

alias ln='ln -i'

# change file properties
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# change to root user
alias root='sudo -i'

# pass default options to free #
if [ $(command -v $(which free)) ]; then
    alias free='free -m -l -t'
fi

# ps command aliases
if [ $(command -v $(which ps)) ]; then
    alias ps="ps auxf --sort=-pcpu,+pmem"

    ## get top process eating memory
    alias psmem='ps auxf | sort -nr -k 4'
    alias psmem10='ps auxf | sort -nr -k 4 | head -10'

    ## get top process eating cpu ##
    alias pscpu='ps auxf | sort -nr -k 3'
    alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
fi

# Pretty Print path
alias path='util log-header "PATH(s)" && echo -e "$(echo $PATH | tr ":" "\n" | nl)"'

# Disk aliases
alias df="df -Tha --total"
alias du="du -ach"

# print the environment variables in sorted order
envs() {
    if [ -n "${@}" ]; then
        env ${@} | sort
        return
    fi

    env -v | sort
}

if [ $(command -v $(which scp)) ]; then
    # Secure Copy from <source> to <destination>
    # scp -Cpvr <file/directory in local machine> <remote_machine>:<remote_machine_directory>
    alias scp="scp -CTpvr"
fi

# directory and file handling
alias rm='rm -rfv'
alias mv='mv -vi'
alias cp='cp -vi'
alias mkdir='mkdir -pv'

if [ $(command -v $(which ccat)) ]; then
    alias cat='ccat'
elif [ $(command -v $(which bat)) ]; then
    alias cat='$(which bat) --theme=ansi-light'
fi

# Use NeoVim if it is installed Neither do vim
vimrc='${DOTFILES_PATH}/config/vimrc'
if [ $(command -v $(which nvim)) ]; then
    alias vim="$(which nvim) -u ${vimrc}"
else
    alias vim="vim -u ${vimrc}"
fi

_historyfile_config() {
    # From: https://www.soberkoder.com/better-zsh-history/

    # setopt -o sharehistory
    # setopt -o incappendhistory
    export HISTFILE=${HOME}/.zsh_history
    export HISTFILESIZE=100000 # This is for Zsh
    export SAVEHIST=1000

    setopt INC_APPEND_HISTORY
    export HISTTIMEFORMAT="[%F %T] "

    setopt EXTENDED_HISTORY
    setopt HIST_IGNORE_ALL_DUPS
    setopt HIST_FIND_NO_DUPS

}
_historyfile_config && unset -f _historyfile_config

_git_config() {
    if [ ! $(command -v git) ]; then
        util log-warning "${SCRIPT_NAME}" "'command: git not found'. git configurations are not loaded"
        return
    fi

    if [ ! -d "${DOTFILES_MACHINE_PATH}/git" ]; then
        echo -e "Copying git configuration to machine directory"
        cp -r -v ${DOTFILES_PATH}/config/git "${DOTFILES_MACHINE_PATH}/git"
    else
        # we have already generated the machine specific git configuration.
        # no need to update the config.
        # If you like to update the git config, delete the git directory in DOTFILES_MACHINE_PATH
        return
    fi

    git config --global include.path ${DOTFILES_MACHINE_PATH}/git/gitconfig
    git config --global core.excludesfile ${DOTFILES_MACHINE_PATH}/git/gitignore
    git config --global commit.template ${DOTFILES_MACHINE_PATH}/git/gitmessage
    git config --global credential.helper 'store --file ${DOTFILES_MACHINE_PATH}/git/gitcredentials'

    ## Auto completion for gitextras
    source "${DOTFILES_SUBMODULE_PATH}/git-extras/etc/git-extras-completion.zsh"
}

_git_config && unset -f _git_config

# _hstr_config() {

#     if [ ! $(command -v hstr) ]; then
#         util log-warning "${SCRIPT_NAME}" "'command: hstr not found'. hstr configurations are not loaded"
#         return
#     fi

#     HISTFILESIZE=10000
#     HISTSIZE=${HISTFILESIZE}
#     export HSTR_CONFIG=hicolor,case-sensitive,no-confirm,raw-history-view,warning

#     #if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
#     if [[ $- =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi

#     # if this is interactive shell, then bind 'kill last command' to Ctrl-x k
#     if [[ $- =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi
# }
# _hstr_config && unset -f _hstr_config

# ---- Bashmarks (Directory Bookmark Manager) Setup ----
_bashmarks_init() {

    # Default directory bookmarks
    export DIR_config="${DOTFILES_PATH}"
    export DIR_bashconfig="${DOTFILES_MACHINE_PATH}"
    export DIR_home="$HOME"

    # SDIRS stores the bookmarks of directory, bashmarks will create SDIRS, if it does not exist
    export SDIRS="${DOTFILES_MACHINE_PATH}/bashmarks.sh"

    source "${DOTFILES_PATH}/submodules/bashmarks/bashmarks.sh"
}
_bashmarks_init && unset -f _bashmarks_init

_sshrc_config() {
    #
    # _sshrc_config provides configuration for sshrc tool in bin/ directory
    # It creates a .sshrc file and stores it in DOTFILES_MACHINE_PATH location.
    # when you try ssh(alias of sshrc) or sshrc to connect to remote machine,
    # .sshrc file will run in that remote machine to initaite bashconfig
    #

    if [ -f "${DOTFILES_MACHINE_PATH}/.sshrc" ]; then
        return
    fi

    touch "${DOTFILES_MACHINE_PATH}/.sshrc"
    cat <<EOF >>${DOTFILES_MACHINE_PATH}/.sshrc
#!/usr/bin/env bash

echo "Setting up BashConfig for this Remote machine...."
# removing all aliases
unalias -a

. "$DOTFILES_PATH/bashrc"
EOF

    chmod +x ${DOTFILES_MACHINE_PATH}/.sshrc
}

# _sshrc_config && unset -f _sshrc_config

source "${DOTFILES_PATH}/config/docker/docker.sh"
source "${DOTFILES_PATH}/config/python/python.sh"
source "${DOTFILES_PATH}/config/golang/golang.sh"
# source "${DOTFILES_PATH}/config/autocomplete.sh"
