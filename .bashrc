# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
#export EDITOR=/usr/bin/vim
#export EDITOR=/usr/bin/mcedit

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

test -s ~/.alias && . ~/.alias || true
OPERAPLUGINWRAPPER_PRIORITY=0
OPERA_KEEP_BLOCKED_PLUGIN=1
GDK_NATIVE_WINDOWS=1
export SMLNJ_HOME=$SMLNJ_HOME:/usr/lib/smlnj/

# Enable tab completion
source ~/git-completion.bash

# colors!
green="\[\033[0;32m\]"
blue="\[\033[0;34m\]"
purple="\[\033[0;35m\]"
red="\[\033[0;31m\]"
reset="\[\033[0m\]"

# Change command prompt
source ~/git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
# '\u' adds the name of the current user to the prompt
# '\$(__git_ps1)' adds git-related stuff
# '\W' adds the name of the current directory
export PS1="$purple\u$green\$(__git_ps1)$red \W $ $reset"

#Alias para Sublime Text
alias subl="/windows/D/sublime_text_3/sublime_text"
alias smartgit="/windows/D/smartgit/bin/smartgit.sh"

set meta-flag on        # conservar bit 8 en entrada de teclado
set output-meta on      # conservar bit 8 en salida por terminal
set convert-meta off    # no convertir secuencias de escape
export LC_ALL=es_ES.UTF-8
export LC_CTYPE=es_ES.UTF-8
export LANG=es_ES.UTF-8
export LANGUAGE=es_ES.UTF-8
