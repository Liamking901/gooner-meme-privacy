#!/bin/bash

# Gooner Linux System Setup Script
# Configures privacy and meme features on first boot

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}[SETUP]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Configure Tor networking
setup_tor_networking() {
    print_status "Configuring Tor networking..."
    
    # Backup original iptables
    iptables-save > /tmp/iptables.backup
    
    # Flush existing rules
    iptables -F
    iptables -t nat -F
    
    # Set default policies
    iptables -P INPUT DROP
    iptables -P FORWARD DROP
    iptables -P OUTPUT DROP
    
    # Allow loopback
    iptables -A INPUT -i lo -j ACCEPT
    iptables -A OUTPUT -o lo -j ACCEPT
    
    # Allow established connections
    iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
    
    # Redirect DNS to Tor
    iptables -t nat -A OUTPUT -p udp --dport 53 -j REDIRECT --to-ports 5353
    iptables -t nat -A OUTPUT -p tcp --dport 53 -j REDIRECT --to-ports 5353
    
    # Redirect TCP traffic to Tor (except Tor itself)
    iptables -t nat -A OUTPUT -p tcp --syn -m owner ! --uid-owner debian-tor -j REDIRECT --to-ports 9040
    
    # Allow Tor traffic
    iptables -A OUTPUT -m owner --uid-owner debian-tor -j ACCEPT
    
    # Allow local traffic for Tor
    iptables -A OUTPUT -p tcp --dport 9050 -j ACCEPT
    iptables -A OUTPUT -p tcp --dport 9040 -j ACCEPT
    iptables -A OUTPUT -p tcp --dport 5353 -j ACCEPT
    
    # Save iptables rules
    iptables-save > /etc/iptables/rules.v4
    
    print_status "Tor networking configured!"
}

# Setup MAC address randomization
setup_mac_randomization() {
    print_status "Setting up MAC address randomization..."
    
    cat << 'EOF' > /etc/systemd/network/99-mac-randomization.link
[Match]
Type=wlan

[Link]
MACAddressPolicy=random
EOF
    
    cat << 'EOF' > /etc/systemd/network/99-mac-randomization-eth.link
[Match]
Type=ether

[Link]
MACAddressPolicy=random
EOF
    
    systemctl enable systemd-networkd
    print_status "MAC randomization enabled!"
}

# Configure DNS over Tor
setup_dns() {
    print_status "Configuring DNS over Tor..."
    
    cat << 'EOF' > /etc/resolv.conf
# Gooner Linux DNS Configuration
# DNS queries routed through Tor
nameserver 127.0.0.1
options edns0
EOF
    
    # Make resolv.conf immutable to prevent overwrites
    chattr +i /etc/resolv.conf
    
    print_status "DNS configured!"
}

# Setup privacy-focused sysctl settings
setup_sysctl() {
    print_status "Configuring kernel privacy settings..."
    
    cat << 'EOF' > /etc/sysctl.d/99-gooner-privacy.conf
# Gooner Linux Privacy Settings

# Network privacy
net.ipv4.tcp_timestamps = 0
net.ipv4.tcp_sack = 0
net.ipv4.tcp_window_scaling = 0
net.ipv4.ip_forward = 0
net.ipv6.conf.all.forwarding = 0
net.ipv6.conf.default.forwarding = 0

# Disable IPv6 to prevent leaks
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1

# ICMP redirects
net.ipv4.conf.all.accept_redirects = 0
net.ipv4.conf.default.accept_redirects = 0
net.ipv6.conf.all.accept_redirects = 0
net.ipv6.conf.default.accept_redirects = 0

# Source routing
net.ipv4.conf.all.accept_source_route = 0
net.ipv4.conf.default.accept_source_route = 0
net.ipv6.conf.all.accept_source_route = 0
net.ipv6.conf.default.accept_source_route = 0

# Log martians
net.ipv4.conf.all.log_martians = 1

# Ignore ping requests
net.ipv4.icmp_echo_ignore_all = 1

# Memory and process protection
kernel.dmesg_restrict = 1
kernel.kptr_restrict = 2
kernel.yama.ptrace_scope = 1
kernel.core_pattern = /dev/null

# Swap protection
vm.swappiness = 1
EOF
    
    sysctl -p /etc/sysctl.d/99-gooner-privacy.conf
    print_status "Kernel settings configured!"
}

# Disable telemetry and tracking services
disable_telemetry() {
    print_status "Disabling telemetry and tracking..."
    
    # Disable various tracking services if they exist
    services_to_disable=(
        "apport"
        "whoopsie"
        "popularity-contest"
        "apt-daily"
        "apt-daily-upgrade"
        "motd-news"
        "ubuntu-report"
    )
    
    for service in "${services_to_disable[@]}"; do
        if systemctl list-unit-files | grep -q "$service"; then
            systemctl disable "$service" 2>/dev/null || true
            systemctl mask "$service" 2>/dev/null || true
        fi
    done
    
    # Remove telemetry packages if installed
    apt purge -y apport whoopsie popularity-contest ubuntu-report 2>/dev/null || true
    
    print_status "Telemetry disabled!"
}

# Setup meme directories and content
setup_memes() {
    print_status "Setting up meme content..."
    
    # Create meme directories
    mkdir -p /home/gooner/memes/{images,sounds,ascii}
    
    # Create some ASCII art
    cat << 'EOF' > /home/gooner/memes/ascii/chad.txt
⠀⠀⠘⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡜⠀⠀⠀
⠀⠀⠀⠑⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡔⠁⠀⠀⠀
⠀⠀⠀⠀⠈⠢⢄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠴⠊⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢸⠀⠀⠀⢀⣀⣀⣀⣀⣀⡀⠤⠄⠒⠈⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠘⣀⠄⠊⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡠⠔⠒⠒⠒⠒⠒⠢⠤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⡰⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠑⢄⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⡸⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠙⠄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠃⠀⢠⠂⠀⠀⠘⡄⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢸⠀⠀⠀⠀⠀⠀⠀⠀⠈⢤⡀⢂⠀⢨⠀⢀⡠⠈⢣⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⢀⡖⠒⠶⠤⠭⢽⣟⣗⠲⠖⠺⣖⣴⣆⡤⠤⠤⠼⡄⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠘⡈⠃⠀⠀⠀⠘⣺⡟⢻⠻⡆⠀⡏⠀⡸⣿⢿⢞⠄⡇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢣⡀⠤⡀⡀⡔⠉⣏⡿⠛⠓⠊⠁⠀⢎⠛⡗⡗⢳⡏⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢱⠀⠨⡇⠃⠀⢻⠁⡔⢡⠒⢀⠀⠀⡅⢹⣿⢨⠇⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢸⠀⠠⢼⠀⠀⡎⡜⠒⢀⠭⡖⡤⢭⣱⢸⢙⠆⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⡸⠀⠀⠸⢁⡀⠿⠈⠂⣿⣿⣿⣿⣿⡏⡍⡏⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⠇⠀⠀⠀⠀⠸⢢⣫⢀⠘⣿⣿⡿⠏⣼⡏⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣀⣠⠊⠀⣀⠎⠁⠀⠀⠀⠙⠳⢴⡦⡴⢶⣞⣁⣀⣀⡀⠀⠀⠀⠀⠀
⠀⠐⠒⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠠⠀⢀⠤⠀⠀⠀⠀⠀⠀⠀⠈⠉⠀⠀⠀⠀

YES.
EOF

    cat << 'EOF' > /home/gooner/memes/ascii/doge.txt
                          ░░░░░░░░░▄░░░░░░░░░░░░░░▄░░░░
                          ░░░░░░░░▌▒█░░░░░░░░░░░▄▀▒▌░░░
                          ░░░░░░░░▌▒▒█░░░░░░░░▄▀▒▒▒▐░░░
                          ░░░░░░░▐▄▀▒▒▀▀▀▀▄▄▄▀▒▒▒▒▒▐░░░
                          ░░░░░▄▄▀▒░▒▒▒▒▒▒▒▒▒█▒▒▄█▒▐░░░
                          ░░░▄▀▒▒▒░░░▒▒▒░░░▒▒▒▀██▀▒▌░░░
                          ░░▐▒▒▒▄▄▒▒▒▒░░░▒▒▒▒▒▒▒▀▄▒▒▌░░
                          ░░▌░░▌█▀▒▒▒▒▒▄▀█▄▒▒▒▒▒▒▒█▒▐░░
                          ░▐░░░▒▒▒▒▒▒▒▒▌██▀▒▒░░░▒▒▒▀▄▌░
                          ░▌░▒▄██▄▒▒▒▒▒▒▒▒▒░░░░░░▒▒▒▒▌░
                          ▀▒▀▐▄█▄█▌▄░▀▒▒░░░░░░░░░░▒▒▒▐░
                          ▐▒▒▐▀▐▀▒░▄▄▒▄▒▒▒▒▒▒░▒░▒░▒▒▒▒▌
                          ▐▒▒▒▀▀▄▄▒▒▒▄▒▒▒▒▒▒▒▒░▒░▒░▒▒▐░
                          ░▌▒▒▒▒▒▒▀▀▀▒▒▒▒▒▒░▒░▒░▒░▒▒▒▌░
                          ░▐▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▒▄▒▒▐░░
                          ░░▀▄▒▒▒▒▒▒▒▒▒▒▒░▒░▒░▒▄▒▒▒▒▌░░
                          ░░░░▀▄▒▒▒▒▒▒▒▒▒▒▄▄▄▀▒▒▒▒▄▀░░░
                          ░░░░░░▀▄▄▄▄▄▄▀▀▀▒▒▒▒▒▄▄▀░░░░░
                          ░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▀▀░░░░░░░░

                              wow such privacy
                                    much anonymous
                                 very secure
EOF

    # Set ownership
    chown -R gooner:gooner /home/gooner/memes
    
    print_status "Meme content ready!"
}

# Configure automatic Tor bridge setup
setup_tor_bridges() {
    print_status "Setting up Tor bridge configuration..."
    
    cat << 'EOF' > /etc/tor/torrc.d/bridges.conf
# Gooner Linux Tor Bridge Configuration
# Uncomment and configure bridges if needed in restrictive networks

# Example obfs4 bridges (replace with current bridges from torproject.org)
#UseBridges 1
#ClientTransportPlugin obfs4 exec /usr/bin/obfs4proxy
#Bridge obfs4 192.0.2.1:80 cert=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX iat-mode=0
#Bridge obfs4 192.0.2.2:443 cert=XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX iat-mode=0
EOF
    
    print_status "Bridge configuration ready (disabled by default)!"
}

# Main setup function
main() {
    print_status "Starting Gooner Linux system setup..."
    
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root"
        exit 1
    fi
    
    setup_tor_networking
    setup_mac_randomization
    setup_dns
    setup_sysctl
    disable_telemetry
    setup_memes
    setup_tor_bridges
    
    print_status "Gooner Linux setup complete!"
    print_status "Reboot required for all changes to take effect."
}

# Run main function
main "$@"