# bashrc.local for Linux
#
# Local environment variables
#
export ORGANIZATION="Mirai Consulting"

# distro family -

if [ -f /etc/redhat-release ]; then
  export LXTYPE=RHEL
elif [ -f /etc/SuSE-release ]; then
  export LXTYPE=SLES
elif [ -f /etc/debian_version ]; then
  export LXTYPE=DEBIAN
fi

# use sudo or not?
#sudo='sudo'
sudo=''

#if [ $SHELL == '/bin/bash' ]; then

#
# Set prompt and aliases to something useful for an interactive shell
#

case "$-" in
*i*)
    #
    # Set prompt to something useful
    #
    case "$is" in
    bash)
        set -p
        if test "$UID" = 0 ; then
            PS1="\u@\h:\w> "
        else
                tty=`tty`
                PS1=`uname -n`': $PWD \n(tty${tty#/dev/tty}): bash: \! > '
        fi
        ;;
    esac

	case $TERM in
		xterm)
			PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
		screen)
			PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
		*)
			PROMPT_COMMAND=''
		;;
	esac

# fix broken non-root path - 
pathmunge () {
        if ! echo $PATH | /bin/egrep -q "(^|:)$1($|:)" ; then
           if [ "$2" = "after" ] ; then
              PATH=$PATH:$1
           else
              PATH=$1:$PATH
           fi
        fi
}

#
# Path manipulation
#

pathmunge /sbin
pathmunge /usr/sbin
pathmunge /usr/local/sbin
pathmunge $HOME/sbin

unset pathmunge

set histexpand
export HISTCONTROL=ignoredups

alias ltr='ls -latr'
alias ll='ls -laFL'
alias lll='ll | less'

alias cls=clear
alias f=finger

if [ $LXTYPE == "SLES" ]; then
  alias msgs='$sudo tail -20 /var/log/messages'
  alias maillog='$sudo tail -20 /var/log/mail'
  alias postlog='$sudo grep postfix /var/log/mail | tail -40'
  alias poplog='$sudo grep pop3-login /var/log/mail | tail -40'
  alias msgs='$sudo tail -20 /var/log/messages'
elif [ $LXTYPE == "DEBIAN" ]; then
  alias msgs='$sudo tail -20 /var/log/syslog'
  alias maillog='$sudo tail -20 /var/log/mail.log'
  alias postlog='$sudo grep postfix /var/log/mail.log | tail -40'
  alias poplog='$sudo grep pop3-login /var/log/mail.log | tail -40'
elif [ $LXTYPE == "RHEL" ]; then
  alias msgs='$sudo tail -20 /var/log/messages'
  alias maillog='$sudo tail -20 /var/log/maillog'
  alias postlog='$sudo grep postfix /var/log/maillog | tail -40'
  alias poplog='$sudo grep pop3-login /var/log/maillog | tail -40'
fi


alias krnl='$sudo tail -20 /var/log/kernel'
alias cmo='ls -Lltr /var/spool/mail'
alias psu='ps -FHu'
alias mqt='mailq|tail'
alias dmesg='/bin/dmesg|tail -40'

/bin/rm -f ~/.project
set `date`
echo "" >> ~/.project
echo " $LOGNAME logged in on `hostname` $1 $2 $3 $4" >> ~/.project
echo "" >> ~/.project

esac

#[ -r /etc/dircolors.sh ] && . /etc/dircolors.sh

alias addkey="sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys"

#fi
