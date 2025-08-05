# Gooner Linux .bashrc
# Privacy-focused meme OS configuration

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# History configuration for privacy
HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=0  # Don't save history to disk for privacy
unset HISTFILE

# Aliases for maximum convenience and memes
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Privacy aliases
alias tor-status='systemctl status tor'
alias tor-check='curl --socks5 127.0.0.1:9050 https://check.torproject.org'
alias new-identity='sudo systemctl reload tor'
alias firewall='sudo ufw status'

# Meme aliases
alias chad='/usr/local/bin/goon-ascii.sh && neofetch'
alias matrix='cmatrix'
alias joke='gooner-joke'
alias shrek='~/run_shrek.sh'
alias rainbow='lolcat'

# Security aliases
alias secure-delete='shred -vfz -n 3'
alias wipe-ram='sudo sysctl vm.drop_caches=3'
alias check-connections='ss -tuln'
alias scan-local='nmap -sn 192.168.1.0/24'

# Directory shortcuts
alias memes='cd ~/memes'
alias configs='cd ~/.config'

# Enable color support
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
fi

# Custom prompt with privacy indicator
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@gooner-linux\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@gooner-linux:\w\$ '
fi

# Set terminal title
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@gooner-linux: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# Function to display Tor status in prompt
tor_status() {
    if systemctl is-active --quiet tor; then
        echo -e "\033[32m[TOR]\033[0m"
    else
        echo -e "\033[31m[NO-TOR]\033[0m"
    fi
}

# Enhanced prompt with Tor status
PS1="$(tor_status) $PS1"

# Custom Goon OS ASCII art welcome
/usr/local/bin/goon-ascii.sh

echo
echo "Type 'chad' for full system info, 'joke' for spicy memes, or 'shrek' for easter egg"
echo "Your traffic is routed through Tor by default. Type 'tor-check' to verify."
echo

# Check Tor status on login
if systemctl is-active --quiet tor; then
    echo -e "\033[32m✓ Tor is running and protecting your privacy\033[0m"
else
    echo -e "\033[31m⚠ Warning: Tor is not running! Your traffic may not be anonymous\033[0m"
fi

echo

# Privacy tip of the day
privacy_tips=(
    "Remember: Trust but verify. Always check your Tor connection!"
    "Pro tip: Use 'new-identity' to get a fresh Tor circuit"
    "Privacy fact: Your MAC address is randomized on each boot"
    "Meme wisdom: Stay anonymous, stay memey!"
    "Security reminder: This system leaves no traces when you reboot"
    "Chad move: Always verify checksums before trusting downloads"
)

echo "💡 Privacy tip: ${privacy_tips[RANDOM % ${#privacy_tips[@]}]}"
echo

# Enable bash completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Custom functions
weather() {
    curl -s "wttr.in/$1?m" | head -n 7
}

qr() {
    echo "$1" | curl -F-=\<- qrenco.de
}

# Tor-ify function
torify-app() {
    if [ $# -eq 0 ]; then
        echo "Usage: torify-app <command>"
        return 1
    fi
    torsocks "$@"
}

# System cleanup function
cleanup-system() {
    echo "Cleaning up system..."
    sudo apt autoremove -y
    sudo apt autoclean
    sudo journalctl --vacuum-time=1d
    sudo shred -vfz -n 3 ~/.bash_history 2>/dev/null || true
    history -c
    echo "System cleaned up!"
}

# Check for updates (but don't auto-install for privacy)
check-updates() {
    echo "Checking for package updates..."
    apt list --upgradable 2>/dev/null | grep -v "WARNING"
}

# Generate secure password
genpass() {
    local length=${1:-16}
    tr -dc 'A-Za-z0-9!@#$%^&*()_+' < /dev/urandom | head -c "$length" && echo
}

# Export functions
export -f weather qr torify-app cleanup-system check-updates genpass