#!/bin/bash

UNAME="$(uname)"
IS_MAC=$(expr "$UNAME" = "Darwin")
IS_LINUX=$(expr "$UNAME" = "Linux")

# Source global definitions
if [ -f /etc/bashrc ]; then
    source /etc/bashrc
fi

#######################################################
# EXPORTS
#######################################################

# Expand the history size
export HISTFILESIZE=10000
export HISTSIZE=500

# Don't put duplicate lines in the history and do not add lines that start with a space
export HISTCONTROL=erasedups:ignoredups:ignorespace

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize

# Causes bash to append to history instead of overwriting it so if you start a new terminal, you have old session history
shopt -s histappend
PROMPT_COMMAND='history -a'

# Allow ctrl-S for history navigation (with ctrl-R)
stty -ixon

# Set the default editor
export EDITOR=vim
export VISUAL=vim

# Enable colors for all commands
export CLICOLOR=1
export LS_COLORS='no=00:fi=00:di=00;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:*.xml=00;31:'

# Color for manpages in less makes manpages a little easier to read
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

export PS1="[\[\e[32m\]\u\[\e[m\]@\[\e[36m\]\h\[\e[m\]:\[\e[35m\]\w\[\e[m\]]  "

#######################################################
# ALIASES
#######################################################
# Ignore an alias by prefixing the command with \, e.g. \ls

alias cp='cp -i' # confirm overwrite
alias mv='mv -i' # confirm overwrite
alias mkdir='mkdir -p' # create all dirs on path
alias ps='ps aux'
alias less='less -R' # refresh screen
alias cls='clear'
alias apt-get='sudo apt-get'
alias gdb='gdb -q'

# Colors
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Change directory aliases
alias home='cd ~'
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias bd='cd -' # go to previous directory ($OLDPWD)

# Remove a directory and all files
alias rmd='/bin/rm -rf'

alias la='ls -Alh' # show hidden files
alias ll='ls -Fls' # long listing format
alias lf="ls -l | egrep -v '^d'" # files only
alias ldir="ls -l | egrep '^d'" # directories only

# alias chmod commands
alias mx='chmod a+x'
alias 000='chmod -R 000'
alias 644='chmod -R 644'
alias 666='chmod -R 666'
alias 755='chmod -R 755'
alias 777='chmod -R 777'

# Search running processes
if [ $IS_LINUX = 1 ]; then
    alias p="ps aux | grep "
    alias topcpu="/bin/ps -eo pcpu,pid,user,args | sort -k 1 -r | head -10"
fi

alias mktar='tar -cvf'
alias mkbz2='tar -cvjf'
alias mkgz='tar -cvzf'
alias untar='tar -xvf'
alias unbz2='tar -xvjf'
alias ungz='tar -xvzf'

# Git
alias ga='git add'
alias gc='git commit'
alias gs='git status'
alias gd='git diff'
alias gp='git push origin master'

if [ $IS_MAC = 1 ]; then
    alias md5sum='md5'
    alias sha1sum='openssl sha1'
fi

#######################################################
# FUNCTIONS
#######################################################

function extract() {
    for archive in $*; do
        if [ -f $archive ] ; then
            case $archive in
                *.tar.bz2)   tar xvjf $archive    ;;
                *.tar.gz)    tar xvzf $archive    ;;
                *.bz2)       bunzip2 $archive     ;;
                *.rar)       rar x $archive       ;;
                *.gz)        gunzip $archive      ;;
                *.tar)       tar xvf $archive     ;;
                *.tbz2)      tar xvjf $archive    ;;
                *.tgz)       tar xvzf $archive    ;;
                *.zip)       unzip $archive       ;;
                *.Z)         uncompress $archive  ;;
                *.7z)        7z x $archive        ;;
                *)           echo "don't know how to extract '$archive'..." ;;
            esac
        else
            echo "'$archive' is not a valid file!"
        fi
    done
}

# Create and go to the directory
function mkdirg() {
    mkdir -p $1
    cd $1
}

# Goes up a specified number of directories  (i.e. up 4)
function up() {
    local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++))
        do
            d=$d/..
        done
    d=$(echo $d | sed 's/^\///')
    if [ -z "$d" ]; then
        d=..
    fi
    cd $d
}

function myip() {
    if [ $IS_MAC = 1 ]; then
        echo -n "Internal: " ; /sbin/ifconfig en0 | grep "inet " | awk -F' ' '{print $2}'
    elif [ $IS_LINUX = 1 ]; then
        echo -n "Internal: " ; /sbin/ifconfig eth0 | grep "inet " | awk -F" " '{print $2}'
    fi
    echo -n "External: " ; curl https://ipecho.net/plain -q
    echo
}

# Fuzzy finder
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
