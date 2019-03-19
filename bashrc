# bashrc

export EDITOR=emacs

export DEBFULLNAME="Gerd Pauli"
export DEBEMAIL="gp@high-consulting.de"

# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# don't put duplicate lines in the history. See bash(1) for more options
export HISTCONTROL=ignoredups:erasedups
HISTSIZE=5000
HISTFILESIZE=$HISTSIZE
HISTIGNORE="history*:fg:bg:man*"
HISTTIMEFORMAT="%d.%m.%Y %H:%M:%S "

if [[ $TERM == "xterm-256color" ]] ; then
    TERM=xterm-debian
fi

# append history entries..
shopt -s histappend
# reedit a history substitution line if it failed
shopt -s histreedit
# edit a recalled history line before executing
shopt -s histverify

function build_prompt {
    HOST=$(hostname)
    TTYL=$(tty)
    TTY=${TTYL##*/}
    P=$(pwd)
    m="^$HOME(.*)$"
    GIT_PS1_SHOWDIRTYSTATE=1
    GIT_PS1_SHOWSTASHSTATE=1
    GIT_PS1_SHOWUNTRACKEDFILES=1
    # Explicitly unset color (default anyhow). Use 1 to set it.
    GIT_PS1_SHOWCOLORHINTS=
    GIT_PS1_DESCRIBE_STYLE="branch"
    GIT_PS1_SHOWUPSTREAM="auto git"

    if [[ $P =~ $m ]] ; then
	P="~${BASH_REMATCH[1]}"
    fi
    if [[ "$TERM" =~ "xterm" ]] ; then
	echo -en "\033]0;${USER}@${HOST}(${TTY}):${P}\007"
    fi
    # set prompt
    if [[ ${COLORTERM} = "truecolor" ]] || \
	[[ ${TERM} =~ "xterm" ]]; then
	if [[ ${UID} == 0 ]] ; then
	    PS1="\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\W\[\033[00m\]\[\033[01;35m\]$(__git_ps1 " (%s)")\[\033[00m\]# "
	else
	    PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;35m\]$(__git_ps1 " (%s)")\[\033[00m\]\$ "
	fi
    else
	if [[ ${EUID} == 0 ]] ; then
	    PS1='\u@\h:\w$(__git_ps1 " (%s)")# '
	else
	    PS1='\u@\h:\w$(__git_ps1 " (%s)")\$ '
	fi
    fi
}

colors() {
    local fgc bgc vals seq0
    
    printf "Color escapes are %s\n" '\e[${value};...;${value}m'
    printf "Values 30..37 are \e[33mforeground colors\e[m\n"
    printf "Values 40..47 are \e[43mbackground colors\e[m\n"
    printf "Value  1 gives a  \e[1mbold-faced look\e[m\n\n"
    
    # foreground colors
    for fgc in {30..37}; do
	# background colors
	for bgc in {40..47}; do
	    fgc=${fgc#37} # white
	    bgc=${bgc#40} # black
	    
	    vals="${fgc:+$fgc;}${bgc}"
	    vals=${vals%%;}
	    
	    seq0="${vals:+\e[${vals}m}"
	    printf "  %-9s" "${seq0:-(default)}"
	    printf " ${seq0}TEXT\e[m"
	    printf " \e[${vals:+${vals+$vals;}}1mBOLD\e[m\n"
	done
	echo; echo
    done
}

if [[ ${COLORTERM} = "truecolor" ]] || \
       [[ ${TERM} =~ "xterm" ]]; then
    export LS_OPTIONS='--color=auto'
    alias ls='ls $LS_OPTIONS'
    alias ll='ls $LS_OPTIONS -l'
    alias l='ls $LS_OPTIONS -lA'
fi

export PROMPT_COMMAND='build_prompt'

source ~/.git-prompt

