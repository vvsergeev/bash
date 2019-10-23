#!/usr/bin/env bash

# Little preporation for Astra linux (Debian Like)

apt install bindutils tcpdump curl wget nmap net-tools telnet -y

# Customize /etc/profile
cat << EOF >> /etc/profile
#custom config starts here
echo MY-SRV > /etc/region
REGION=\$(cat /etc/region)
export REGION

if [[ \$UID == 0 ]]
    then
    PS1="\[\033[00m\][\[\033[1;32m\]$REGION\[\033[00m\]|\[\033[1;31m\]\u\[\033[1;37m\]@\[\033[1;33m\]\h\[\033[1;37m\]:\[\033[1;31m\]\w\[\033[00m\]]\[\033[1;31m\]#\$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]F\") \[\033[00m\]"
    else
    PS1="\[\033[00m\][\[\033[1;32m\]\$REGION\[\033[00m\]|\[\033[1;34m\]\u\[\033[1;37m\]@\[\033[1;33m\]\h\[\033[1;37m\]:\[\033[1;34m\]\w\[\033[00m\]]\[\033[1;34m\]$ \$([[ \$? != 0 ]] && echo \"\[\033[01;31m\]F\") \[\033[00m\]"
fi

# aliases
alias grep='grep --colour=auto'
alias cp='cp -r'
alias scp='scp -r'
alias rm='rm -r'
alias mkdir='mkdir -p'
alias ls='ls -F --color=auto'
alias la='ls -A --color=auto'
alias ll='ls -l --color=auto -h'
alias lla='ll -A --color=auto -h'
which colordiff >/dev/null && alias diff='colordiff'

# some nice functions thanks to Vasily Laur
# classic archive extractor
extract () {
    if [ -f \$1 ] ; then
        case \$1 in
            *.tar.bz2) tar xvjf \$1   ;;
            *.tar.gz)  tar xvzf \$1   ;;
            *.bz2)     bunzip2 \$1    ;;
            *.rar)     unrar x \$1    ;;
            *.gz)      gunzip \$1     ;;
            *.tar)     tar xvf \$1    ;;
            *.tbz2)    tar xvjf \$1   ;;
            *.tgz)     tar xvzf \$1   ;;
            *.zip)     unzip \$1      ;;
            *.Z)       uncompress \$1 ;;
            *.7z)      7z x \$1       ;;
            *)         echo "'\$1' cannot be extracted via $0" ;;
        esac
    else
        echo "'\$1' is not a valid file"
    fi
}
EOF
