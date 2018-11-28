#!/bin/bash

# set time and timezone to Moscow time
unlink /etc/localtime
ln -s /usr/share/zoneinfo/Europe/Moscow /etc/localtime
#timedatectl set-timezone 'Europe/Moscow'

# configure proxy
cat << EOF >> /etc/proxy.conf
username=
# Primitive hiding password (it is not secure). Insert base64 code here
PASS_B64=
purl=proxy.domain.com
port=3128

MY_PROXY_URL="\$username:\$(echo \$PASS_B64 | base64 --decode)@\$purl:$port"
HTTP_PROXY=\$MY_PROXY_URL
HTTPS_PROXY=\$MY_PROXY_URL
FTP_PROXY=\$MY_PROXY_URL
http_proxy=\$MY_PROXY_URL
https_proxy=\$MY_PROXY_URL
ftp_proxy=\$MY_PROXY_URL

export HTTP_PROXY HTTPS_PROXY FTP_PROXY http_proxy https_proxy ftp_proxy
EOF
source /etc/proxy.conf

# Configure bashrc in /etc/profile

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

# configure ssh
cat >> /etc/ssh/ssh_config << FOE
StrictHostKeyChecking no
UserKnownHostsFile=/dev/null
FOE

cat >> /etc/ssh/sshd_config << FOE
UseDNS no
FOE

# configure sudo users without password (not secure)
echo "%wheel        ALL=(ALL)       NOPASSWD: ALL" >> /etc/sudoers

# Install and remove soft (rpm based OS)
yum install -y epel-release tcpdump telnet net-tools bind-utils vim pwgen mlocate colordiff bash-completion

# configure login banner with ascii graphics (use to convert text to image http://patorjk.com/software/taag)
cat << EOF >> /etc/motd

EOF

# configure vim
printf "\ncolorscheme torte" >> /etc/vimrc
