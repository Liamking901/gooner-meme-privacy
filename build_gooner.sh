#!/bin/bash

# Gooner Linux ISO Builder Script
# Privacy-focused meme OS based on Debian 12
# Author: Gooner Linux Team
# Version: 1.0.0-chad

set -e  # Exit on any error

# Check if running in Docker
if [[ "$DOCKER_BUILD" == "1" ]]; then
    echo "Running in Docker container - skipping root check"
    SKIP_ROOT_CHECK=1
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ASCII Art Banner
echo -e "${GREEN}"
cat << "EOF"
   ▄██████▄   ▄██████▄   ▄██████▄  ███▄▄▄▄      ▄████████    ▄████████ 
  ███    ███ ███    ███ ███    ███ ███▀▀▀██▄   ███    ███   ███    ███ 
  ███    █▀  ███    ███ ███    ███ ███   ███   ███    █▀    ███    ███ 
 ▄███        ███    ███ ███    ███ ███   ███  ▄███▄▄▄      ▄███▄▄▄▄██▀ 
▀▀███ ████▄  ███    ███ ███    ███ ███   ███ ▀▀███▀▀▀     ▀▀███▀▀▀▀▀   
  ███    ███ ███    ███ ███    ███ ███   ███   ███    █▄  ▀███████████ 
  ███    ███ ███    ███ ███    ███ ███   ███   ███    ███   ███    ███ 
  ████████▀   ▀██████▀   ▀██████▀   ▀█   █▀    ██████████   ███    ███ 
                                                             ███    ███ 
               LINUX - Privacy-focused meme OS
EOF
echo -e "${NC}"

# Configuration
WORK_DIR="$(pwd)/gooner-build"
ISO_NAME="gooner-linux-v1.0.0-chad.iso"
DEBIAN_MIRROR="http://deb.debian.org/debian"
DEBIAN_SUITE="bookworm"
ARCHITECTURE="amd64"

# Function to print colored messages
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_meme() {
    echo -e "${PURPLE}[MEME]${NC} $1"
}

# Check if running as root
check_root() {
    if [[ "$SKIP_ROOT_CHECK" != "1" ]] && [[ $EUID -eq 0 ]]; then
        print_error "Hey bruv, don't run this as root! Use sudo when needed."
        exit 1
    fi
}

# Check dependencies
check_dependencies() {
    print_status "Checking dependencies..."
    
    local deps=("debootstrap" "squashfs-tools" "xorriso" "syslinux-utils" "isolinux")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null && ! dpkg -l | grep -q "^ii  $dep "; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        print_error "Missing dependencies: ${missing[*]}"
        print_status "Installing missing packages..."
        sudo apt update
        sudo apt install -y "${missing[@]}"
    fi
    
    print_success "All dependencies satisfied!"
}

# Cleanup function for safe unmounting
cleanup_mounts() {
    print_status "Cleaning up mounts..."
    
    # Unmount in reverse order
    for mount_point in "/dev/pts" "/dev" "/proc" "/sys"; do
        if mountpoint -q "$WORK_DIR/chroot$mount_point" 2>/dev/null; then
            print_status "Unmounting $WORK_DIR/chroot$mount_point"
            sudo umount -l "$WORK_DIR/chroot$mount_point" || true
        fi
    done
    
    # Wait a moment for unmounts to complete
    sleep 2
}

# Setup build environment
setup_build_env() {
    print_status "Setting up build environment..."
    
    if [[ -d "$WORK_DIR" ]]; then
        print_warning "Build directory exists. Cleaning up..."
        cleanup_mounts
        sudo rm -rf "$WORK_DIR"
    fi
    
    mkdir -p "$WORK_DIR"/{chroot,iso/{live,boot/grub,isolinux},tmp}
    print_success "Build environment ready!"
}

# Bootstrap base system
bootstrap_system() {
    print_status "Bootstrapping Debian base system..."
    print_meme "Downloading packages like a chad..."
    
    sudo debootstrap \
        --arch="$ARCHITECTURE" \
        --variant=minbase \
        --include="systemd-sysv,locales,keyboard-configuration" \
        "$DEBIAN_SUITE" \
        "$WORK_DIR/chroot" \
        "$DEBIAN_MIRROR"
    
    print_success "Base system bootstrapped!"
}

# Configure chroot environment with proper mounting
configure_chroot() {
    print_status "Configuring chroot environment..."
    
    # Copy resolv.conf for internet access
    sudo cp /etc/resolv.conf "$WORK_DIR/chroot/etc/"
    
    # Create necessary device files first
    sudo mkdir -p "$WORK_DIR/chroot/dev/pts"
    
    # Mount necessary filesystems with proper options
    print_status "Mounting filesystems for chroot..."
    
    sudo mount --bind /dev "$WORK_DIR/chroot/dev"
    sudo mount --bind /dev/pts "$WORK_DIR/chroot/dev/pts"
    sudo mount --bind /proc "$WORK_DIR/chroot/proc"
    sudo mount --bind /sys "$WORK_DIR/chroot/sys"
    
    # Verify mounts
    if ! mountpoint -q "$WORK_DIR/chroot/dev"; then
        print_error "Failed to mount /dev"
        exit 1
    fi
    
    if ! mountpoint -q "$WORK_DIR/chroot/proc"; then
        print_error "Failed to mount /proc"
        exit 1
    fi
    
    if ! mountpoint -q "$WORK_DIR/chroot/sys"; then
        print_error "Failed to mount /sys"
        exit 1
    fi
    
    # Configure APT sources
    cat << EOF | sudo tee "$WORK_DIR/chroot/etc/apt/sources.list"
deb $DEBIAN_MIRROR $DEBIAN_SUITE main contrib non-free non-free-firmware
deb-src $DEBIAN_MIRROR $DEBIAN_SUITE main contrib non-free non-free-firmware
deb $DEBIAN_MIRROR $DEBIAN_SUITE-security main contrib non-free non-free-firmware
deb-src $DEBIAN_MIRROR $DEBIAN_SUITE-security main contrib non-free non-free-firmware
deb $DEBIAN_MIRROR $DEBIAN_SUITE-updates main contrib non-free non-free-firmware
deb-src $DEBIAN_MIRROR $DEBIAN_SUITE-updates main contrib non-free non-free-firmware
EOF
    
    print_success "Chroot environment configured!"
}

# Install packages in chroot
install_packages() {
    print_status "Installing packages in chroot..."
    print_meme "Adding the good stuff..."
    
    # Core system packages
    local core_packages=(
        "linux-image-amd64" "live-boot" "systemd-sysv"
        "network-manager" "wireless-tools" "wpasupplicant"
        "sudo" "curl" "wget" "git" "vim" "nano"
        "htop" "neofetch" "tree" "unzip" "p7zip-full"
        "firefox-esr" "xfce4" "xfce4-terminal" "lightdm"
        "network-manager-gnome" "pulseaudio" "alsa-utils"
        "dbus-x11" "ca-certificates"
    )
    
    # Privacy and security packages  
    local privacy_packages=(
        "tor" "torsocks" "proxychains4" "nyx"
        "ufw" "nftables" "macchanger" "bleachbit"
        "secure-delete" "mat2" 
        "openvpn" "wireguard" "resolvconf"
    )
    
    # Hacker tools
    local hacker_packages=(
        "nmap" "netcat-openbsd" "tcpdump" "wireshark"
        "aircrack-ng" "hashcat" "john" "hydra"
        "sqlmap" "nikto" "dirb" "gobuster"
    )
    
    # Meme and fun packages
    local fun_packages=(
        "cowsay" "figlet" "lolcat" "fortune-mod"
        "cmatrix" "sl" "toilet" "espeak"
        "mpv" "feh" "scrot" "imagemagick"
    )
    
    local all_packages=("${core_packages[@]}" "${privacy_packages[@]}" "${hacker_packages[@]}" "${fun_packages[@]}")
    
    # Install packages in chroot with proper environment
    sudo chroot "$WORK_DIR/chroot" /bin/bash -c "
        export DEBIAN_FRONTEND=noninteractive
        export DEBCONF_NONINTERACTIVE_SEEN=true
        export LC_ALL=C
        export LANGUAGE=C
        export LANG=C
        
        # Update package lists
        apt update
        
        # Install packages in batches to avoid issues
        for pkg in ${all_packages[*]}; do
            echo \"Installing \$pkg...\"
            apt install -y \"\$pkg\" || echo \"Failed to install \$pkg, continuing...\"
        done
        
        # Clean up
        apt clean
        apt autoremove -y
    "
    
    print_success "Packages installed!"
}

# Configure Tor
configure_tor() {
    print_status "Configuring Tor for maximum privacy..."
    
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/tor/torrc"
# Gooner Linux Tor Configuration
SocksPort 9050
DNSPort 5353
TransPort 9040
Log notice file /var/log/tor/notices.log

# Circuit building
CircuitBuildTimeout 60
KeepalivePeriod 60
NewCircuitPeriod 30
MaxCircuitDirtiness 600

# Directory servers
FetchDirInfoEarly 1
FetchDirInfoExtraEarly 1

# Guard nodes
UseEntryGuards 1
NumEntryGuards 3

# Bandwidth
RelayBandwidthRate 100 KBytes
RelayBandwidthBurst 200 KBytes
MaxAdvertisedBandwidth 100 KBytes

# Security
AvoidDiskWrites 1
DisableDebuggerAttachment 1
EOF

    # Enable Tor service
    sudo chroot "$WORK_DIR/chroot" systemctl enable tor
    
    print_success "Tor configured!"
}

# Configure firewall
configure_firewall() {
    print_status "Setting up hardened firewall..."
    
    # UFW configuration
    sudo chroot "$WORK_DIR/chroot" /bin/bash -c "
        export DEBIAN_FRONTEND=noninteractive
        ufw --force reset
        ufw default deny incoming
        ufw default deny outgoing
        ufw allow out 9050/tcp
        ufw allow out 9040/tcp
        ufw allow out 5353/tcp
        ufw allow out 53/tcp
        ufw allow out 80/tcp
        ufw allow out 443/tcp
        ufw --force enable
    "
    
    print_success "Firewall configured!"
}

# Setup custom user account
setup_user() {
    print_status "Setting up gooner user account..."
    
    sudo chroot "$WORK_DIR/chroot" /bin/bash -c "
        useradd -m -s /bin/bash -G sudo,audio,video,plugdev,netdev gooner
        echo 'gooner:gooner' | chpasswd
        echo 'gooner ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/gooner
        chmod 440 /etc/sudoers.d/gooner
    "
    
    print_success "User account created!"
}

# Install custom scripts and memes
install_memes() {
    print_status "Installing meme scripts and Easter eggs..."
    print_meme "Adding the spicy content..."
    
    # Create meme scripts directory
    sudo mkdir -p "$WORK_DIR/chroot/usr/local/bin"
    sudo mkdir -p "$WORK_DIR/chroot/home/gooner/memes"
    
    # Gooner joke script with Keir Starmer and anti-censorship memes
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/usr/local/bin/gooner-joke"
#!/bin/bash
jokes=(
    "Why did the privacy advocate cross the road? To avoid being tracked!"
    "What do you call a paranoid penguin? A Linux user!"
    "How many hackers does it take to change a lightbulb? None, they prefer the dark web!"
    "Why don't spies use Windows? Because the NSA already has the keys!"
    "What's a hacker's favorite type of music? Algo-rhythms!"
    "Why did the router go to therapy? It had connection issues!"
    "What do you call a fish wearing a crown? King of the network!"
    "Why don't computers ever get cold? They have Windows!"
    "Keir Starmer walks into a meme... and tries to regulate it!"
    "What's Keir's favorite encryption? Whatever the establishment approves!"
    "Why did Keir Starmer ban VPNs? Because privacy makes him uncomfortable!"
    "What do you call censorship with extra steps? Modern democracy!"
    "Keir Starmer's internet policy: 'You will own nothing and be happy... online!'"
    "Why don't politicians understand encryption? Because they can't handle the truth being secure!"
    "What's the difference between a meme and free speech? Keir Starmer is still figuring it out!"
    "Breaking: Local man discovers Tor, government panics!"
    "What's Keir's favorite browser? Internet Explorer... with tracking enabled!"
    "Why did the gooner cross the road? To escape internet censorship!"
    "What do you call a politician who understands the internet? Unemployed!"
    "Keir Starmer's favorite movie? 1984... as an instruction manual!"
    "What's the government's favorite protocol? HTTP... without the S!"
    "Why do politicians hate decentralization? Because they can't control what they can't understand!"
)
echo "${jokes[RANDOM % ${#jokes[@]}]}"
EOF

    # Shrek Easter egg
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/home/gooner/run_shrek.sh"
#!/bin/bash
echo "SOMEBODY ONCE TOLD ME..."
sleep 1
cat << "SHREK"
⢀⡴⠑⡄⠀⠀⠀⠀⠀⠀⠀⣀⣀⣤⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀ 
⠸⡇⠀⠿⡀⠀⠀⠀⣀⡴⢿⣿⣿⣿⣿⣿⣿⣿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠑⢄⣠⠾⠁⣀⣄⡈⠙⣿⣿⣿⣿⣿⣿⣿⣿⣆⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⢀⡀⠁⠀⠀⠈⠙⠛⠂⠈⣿⣿⣿⣿⣿⠿⡿⢿⣆⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⢀⡾⣁⣀⠀⠴⠂⠙⣗⡀⠀⢻⣿⣿⠭⢤⣴⣦⣤⣹⠀⠀⠀⢀⢴⣶⣆ 
⠀⠀⢀⣾⣿⣿⣿⣷⣮⣽⣾⣿⣥⣴⣿⣿⡿⢂⠔⢚⡿⢿⣿⣦⣴⣾⠁⠸⣼⡿ 
⠀⢀⡞⠁⠙⠻⠿⠟⠉⠀⠛⢹⣿⣿⣿⣿⣿⣌⢤⣼⣿⣾⣿⡟⠉⠀⠀⠀⠀⠀ 
⠀⣾⣷⣶⠇⠀⠀⣤⣄⣀⡀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀ 
⠀⠉⠈⠉⠀⠀⢦⡈⢻⣿⣿⣿⣶⣶⣶⣶⣤⣽⡹⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⠉⠲⣽⡻⢿⣿⣿⣿⣿⣿⣿⣷⣜⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⣿⣷⣶⣮⣭⣽⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⣀⣀⣈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀ 
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⠿⠿⠿⠛⠉
SHREK

THE WORLD IS GONNA ROLL ME
I AIN'T THE SHARPEST TOOL IN THE SHED...

*Plays All Star in terminal*
EOF

    # Make scripts executable
    sudo chmod +x "$WORK_DIR/chroot/usr/local/bin/gooner-joke"
    sudo chmod +x "$WORK_DIR/chroot/home/gooner/run_shrek.sh"
    
    # Copy and install custom Goon OS ASCII script
    sudo cp config/scripts/goon-ascii.sh "$WORK_DIR/chroot/usr/local/bin/"
    sudo chmod +x "$WORK_DIR/chroot/usr/local/bin/goon-ascii.sh"
    
    # Copy Keir Starmer wallpaper and desktop icons
    sudo mkdir -p "$WORK_DIR/chroot/usr/share/pixmaps"
    sudo cp src/assets/keir-starmer-wallpaper.jpg "$WORK_DIR/chroot/usr/share/pixmaps/"
    sudo cp config/icons/desktop-icons.png "$WORK_DIR/chroot/usr/share/pixmaps/"
    
    # Install custom desktop entries
    sudo mkdir -p "$WORK_DIR/chroot/usr/share/applications"
    sudo cp config/desktop/*.desktop "$WORK_DIR/chroot/usr/share/applications/"
    
    # Create desktop shortcuts for user
    sudo cp config/desktop/*.desktop "$WORK_DIR/chroot/home/gooner/Desktop/"
    sudo chmod +x "$WORK_DIR/chroot/home/gooner/Desktop/"*.desktop
    
    # Fix ownership
    sudo chroot "$WORK_DIR/chroot" chown -R gooner:gooner /home/gooner
    
    # Custom sudo prompt
    echo 'Defaults passprompt="Hey bruv, you sure about that? [sudo] password for %p: "' | sudo tee -a "$WORK_DIR/chroot/etc/sudoers"
    
    print_success "Memes installed!"
}

# Configure XFCE and desktop environment
configure_desktop() {
    print_status "Configuring XFCE desktop with custom themes..."
    
    # Install additional XFCE themes and icon packages
    sudo chroot "$WORK_DIR/chroot" /bin/bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt install -y arc-theme numix-icon-theme papirus-icon-theme \
            xfce4-goodies xfce4-panel-profiles xfce4-screenshooter \
            xfce4-taskmanager xfce4-clipman-plugin
    "
    
    # Create desktop configuration directories
    sudo mkdir -p "$WORK_DIR/chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml"
    sudo mkdir -p "$WORK_DIR/chroot/home/gooner/.config/xfce4/xfconf/xfce-perchannel-xml"
    sudo mkdir -p "$WORK_DIR/chroot/etc/skel/.local/share/applications"
    sudo mkdir -p "$WORK_DIR/chroot/home/gooner/.local/share/applications"
    sudo mkdir -p "$WORK_DIR/chroot/home/gooner/Desktop"
    
    # Configure XFCE desktop with custom wallpaper
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="backdrop" type="empty">
    <property name="screen0" type="empty">
      <property name="monitor0" type="empty">
        <property name="workspace0" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/pixmaps/keir-starmer-wallpaper.jpg"/>
        </property>
        <property name="workspace1" type="empty">
          <property name="color-style" type="int" value="0"/>
          <property name="image-style" type="int" value="5"/>
          <property name="last-image" type="string" value="/usr/share/pixmaps/gooner-wallpaper.jpg"/>
        </property>
      </property>
    </property>
  </property>
</channel>
EOF
    
    # Configure XFCE window manager theme
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfwm4.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfwm4" version="1.0">
  <property name="general" type="empty">
    <property name="theme" type="string" value="Arc-Dark"/>
    <property name="title_font" type="string" value="Sans Bold 10"/>
    <property name="button_layout" type="string" value="O|SHMC"/>
    <property name="cycle_draw_frame" type="bool" value="true"/>
    <property name="cycle_raise" type="bool" value="false"/>
    <property name="cycle_hidden" type="bool" value="true"/>
    <property name="cycle_minimum" type="bool" value="true"/>
    <property name="cycle_preview" type="bool" value="true"/>
    <property name="cycle_tabwin_mode" type="int" value="0"/>
    <property name="cycle_apps_only" type="bool" value="false"/>
    <property name="double_click_time" type="int" value="250"/>
    <property name="double_click_distance" type="int" value="5"/>
    <property name="double_click_action" type="string" value="maximize"/>
    <property name="easy_click" type="string" value="Alt"/>
    <property name="focus_delay" type="int" value="250"/>
    <property name="focus_mode" type="string" value="click"/>
    <property name="focus_new" type="bool" value="true"/>
    <property name="raise_delay" type="int" value="250"/>
    <property name="raise_on_click" type="bool" value="true"/>
    <property name="raise_on_focus" type="bool" value="false"/>
    <property name="raise_with_any_button" type="bool" value="true"/>
    <property name="repeat_urgent_blink" type="bool" value="false"/>
    <property name="snap_to_border" type="bool" value="true"/>
    <property name="snap_to_windows" type="bool" value="false"/>
    <property name="snap_width" type="int" value="10"/>
    <property name="vblank_mode" type="string" value="auto"/>
    <property name="wrap_resistance" type="int" value="10"/>
    <property name="wrap_windows" type="bool" value="true"/>
    <property name="wrap_workspaces" type="bool" value="true"/>
    <property name="zoom_desktop" type="bool" value="true"/>
    <property name="zoom_pointer" type="bool" value="true"/>
  </property>
</channel>
EOF

    # Configure XFCE panel with custom layout
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-panel" version="1.0">
  <property name="configver" type="int" value="2"/>
  <property name="panels" type="array">
    <value type="int" value="1"/>
    <property name="panel-1" type="empty">
      <property name="position" type="string" value="p=6;x=0;y=0"/>
      <property name="length" type="uint" value="100"/>
      <property name="position-locked" type="bool" value="true"/>
      <property name="size" type="uint" value="24"/>
      <property name="plugin-ids" type="array">
        <value type="int" value="1"/>
        <value type="int" value="2"/>
        <value type="int" value="3"/>
        <value type="int" value="4"/>
        <value type="int" value="5"/>
        <value type="int" value="6"/>
        <value type="int" value="7"/>
        <value type="int" value="8"/>
      </property>
    </property>
  </property>
  <property name="plugins" type="empty">
    <property name="plugin-1" type="string" value="applicationsmenu"/>
    <property name="plugin-2" type="string" value="tasklist"/>
    <property name="plugin-3" type="string" value="separator"/>
    <property name="plugin-4" type="string" value="systray"/>
    <property name="plugin-5" type="string" value="power-manager-plugin"/>
    <property name="plugin-6" type="string" value="notification-plugin"/>
    <property name="plugin-7" type="string" value="pulseaudio"/>
    <property name="plugin-8" type="string" value="clock"/>
  </property>
</channel>
EOF

    # Set dark theme for applications
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xsettings" version="1.0">
  <property name="Net" type="empty">
    <property name="ThemeName" type="string" value="Arc-Dark"/>
    <property name="IconThemeName" type="string" value="Papirus-Dark"/>
    <property name="DoubleClickTime" type="empty"/>
    <property name="DoubleClickDistance" type="empty"/>
    <property name="DndDragThreshold" type="empty"/>
    <property name="CursorBlink" type="empty"/>
    <property name="CursorBlinkTime" type="empty"/>
    <property name="SoundThemeName" type="empty"/>
    <property name="EnableEventSounds" type="empty"/>
    <property name="EnableInputFeedbackSounds" type="empty"/>
  </property>
  <property name="Xft" type="empty">
    <property name="DPI" type="empty"/>
    <property name="Antialias" type="int" value="1"/>
    <property name="Hinting" type="int" value="1"/>
    <property name="HintStyle" type="string" value="hintslight"/>
    <property name="RGBA" type="string" value="rgb"/>
  </property>
  <property name="Gtk" type="empty">
    <property name="CanChangeAccels" type="empty"/>
    <property name="ColorPalette" type="empty"/>
    <property name="FontName" type="string" value="Sans 10"/>
    <property name="MonospaceFontName" type="string" value="Monospace 10"/>
    <property name="IconSizes" type="empty"/>
    <property name="KeyThemeName" type="empty"/>
    <property name="ToolbarStyle" type="empty"/>
    <property name="ToolbarIconSize" type="empty"/>
    <property name="MenuImages" type="empty"/>
    <property name="ButtonImages" type="empty"/>
    <property name="MenuBarAccel" type="empty"/>
    <property name="CursorThemeName" type="empty"/>
    <property name="CursorThemeSize" type="empty"/>
    <property name="DecorationLayout" type="empty"/>
  </property>
</channel>
EOF
    
    # Configure LightDM for auto-login with dark theme
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/lightdm/lightdm.conf"
[Seat:*]
autologin-user=gooner
autologin-user-timeout=0
user-session=xfce
greeter-session=lightdm-gtk-greeter
EOF

    # Configure LightDM greeter with dark theme
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/lightdm/lightdm-gtk-greeter.conf"
[greeter]
theme-name=Arc-Dark
icon-theme-name=Papirus-Dark
background=/usr/share/pixmaps/keir-starmer-wallpaper.jpg
user-background=false
EOF
    
    # Copy desktop config to user home
    sudo cp -r "$WORK_DIR/chroot/etc/skel/.config" "$WORK_DIR/chroot/home/gooner/"
    sudo chroot "$WORK_DIR/chroot" chown -R gooner:gooner /home/gooner/.config
    
    print_success "Desktop configured with dark themes!"
}

# Configure Plymouth boot splash
configure_plymouth() {
    print_status "Setting up meme boot splash..."
    
    sudo chroot "$WORK_DIR/chroot" /bin/bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt install -y plymouth plymouth-themes
    "
    
    # Create custom plymouth theme
    sudo mkdir -p "$WORK_DIR/chroot/usr/share/plymouth/themes/gooner"
    
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/usr/share/plymouth/themes/gooner/gooner.plymouth"
[Plymouth Theme]
Name=Gooner Linux
Description=Privacy-focused meme OS boot splash
ModuleName=script

[script]
ImageDir=/usr/share/plymouth/themes/gooner
ScriptFile=/usr/share/plymouth/themes/gooner/gooner.script
EOF

    # Create boot splash script
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/usr/share/plymouth/themes/gooner/gooner.script"
message_sprite = Sprite();
message_sprite.SetPosition(Window.GetX() + Window.GetWidth() / 2, Window.GetY() + Window.GetHeight() * 0.9, 10000);

fun message_callback (text) {
    my_image = Image.Text(text, 1, 1, 1);
    message_sprite.SetImage(my_image);
}
Plymouth.SetMessageFunction(message_callback);

# Simple text animation
progress = 0;
fun refresh_callback () {
    progress++;
    messages = ["Booting Like a Chad...", "Loading Memes...", "Activating Privacy Mode...", "Gooner Linux Ready!"];
    current_message = messages[progress % 4];
    message_callback(current_message);
}
Plymouth.SetRefreshFunction (refresh_callback);
EOF
    
    print_success "Plymouth configured!"
}

# Create ISO structure
create_iso_structure() {
    print_status "Creating ISO structure..."
    
    # Find and copy kernel and initrd
    KERNEL_PATH=$(sudo find "$WORK_DIR/chroot/boot" -name "vmlinuz-*" | head -1)
    INITRD_PATH=$(sudo find "$WORK_DIR/chroot/boot" -name "initrd.img-*" | head -1)
    
    if [[ -z "$KERNEL_PATH" ]] || [[ -z "$INITRD_PATH" ]]; then
        print_error "Could not find kernel or initrd files"
        exit 1
    fi
    
    sudo cp "$KERNEL_PATH" "$WORK_DIR/iso/live/vmlinuz"
    sudo cp "$INITRD_PATH" "$WORK_DIR/iso/live/initrd"
    
    # Create GRUB configuration
    cat << 'EOF' | sudo tee "$WORK_DIR/iso/boot/grub/grub.cfg"
set timeout=10
set default=0

menuentry "Boot Like a Chad - Gooner Linux Live" {
    linux /live/vmlinuz boot=live components quiet splash
    initrd /live/initrd
}

menuentry "Gooner Mode: Activated (Safe Graphics)" {
    linux /live/vmlinuz boot=live components quiet splash nomodeset
    initrd /live/initrd
}

menuentry "Memory Test (Check Your RAM, Bruv)" {
    linux16 /live/memtest
}
EOF
    
    # Create isolinux configuration for BIOS boot
    cat << 'EOF' | sudo tee "$WORK_DIR/iso/isolinux/isolinux.cfg"
UI menu.c32
PROMPT 0
MENU TITLE Gooner Linux - Privacy-focused meme OS
TIMEOUT 100

LABEL live
  MENU LABEL Boot Like a Chad - Gooner Linux Live
  MENU DEFAULT
  KERNEL /live/vmlinuz
  APPEND initrd=/live/initrd boot=live components quiet splash

LABEL live-safe
  MENU LABEL Gooner Mode: Activated (Safe Graphics)
  KERNEL /live/vmlinuz
  APPEND initrd=/live/initrd boot=live components quiet splash nomodeset
EOF
    
    print_success "ISO structure created!"
}

# Clean up chroot with proper unmounting
cleanup_chroot() {
    print_status "Cleaning up chroot environment..."
    
    # Clean up inside chroot first
    sudo chroot "$WORK_DIR/chroot" /bin/bash -c "
        apt autoremove -y
        apt autoclean
        rm -rf /tmp/*
        rm -rf /var/tmp/*
        rm -rf /var/log/*
        rm -rf /var/cache/apt/archives/*.deb
        history -c
    " || true
    
    # Remove resolv.conf copy
    sudo rm -f "$WORK_DIR/chroot/etc/resolv.conf"
    
    # Unmount filesystems
    cleanup_mounts
    
    print_success "Chroot cleaned up!"
}

# Create squashfs filesystem
create_squashfs() {
    print_status "Creating squashfs filesystem..."
    print_meme "Compressing like a boss..."
    
    sudo mksquashfs "$WORK_DIR/chroot" "$WORK_DIR/iso/live/filesystem.squashfs" \
        -e boot -comp xz -Xbcj x86 -b 1M -Xdict-size 1M
    
    print_success "Squashfs created!"
}

# Generate ISO
generate_iso() {
    print_status "Generating final ISO..."
    print_meme "Almost ready to yeet this OS..."
    
    # Copy isolinux files
    sudo cp /usr/lib/ISOLINUX/isolinux.bin "$WORK_DIR/iso/isolinux/"
    sudo cp /usr/lib/syslinux/modules/bios/menu.c32 "$WORK_DIR/iso/isolinux/"
    sudo cp /usr/lib/syslinux/modules/bios/hdt.c32 "$WORK_DIR/iso/isolinux/"
    sudo cp /usr/lib/syslinux/modules/bios/ldlinux.c32 "$WORK_DIR/iso/isolinux/"
    sudo cp /usr/lib/syslinux/modules/bios/libcom32.c32 "$WORK_DIR/iso/isolinux/"
    sudo cp /usr/lib/syslinux/modules/bios/libutil.c32 "$WORK_DIR/iso/isolinux/"
    
    # Generate the ISO (simplified for BIOS boot only)
    sudo xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "GOONER_LINUX" \
        -eltorito-boot isolinux/isolinux.bin \
        -eltorito-catalog isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -output "$ISO_NAME" \
        "$WORK_DIR/iso"
    
    print_success "ISO generated: $ISO_NAME"
}

# Calculate checksums
calculate_checksums() {
    print_status "Calculating checksums..."
    
    sha256sum "$ISO_NAME" > "${ISO_NAME}.sha256"
    md5sum "$ISO_NAME" > "${ISO_NAME}.md5"
    
    print_success "Checksums calculated!"
    echo "SHA256: $(cat ${ISO_NAME}.sha256)"
    echo "MD5: $(cat ${ISO_NAME}.md5)"
}

# Trap to cleanup on exit
trap cleanup_mounts EXIT

# Main build function
main() {
    print_meme "Starting Gooner Linux build process..."
    echo
    
    check_root
    check_dependencies
    setup_build_env
    bootstrap_system
    configure_chroot
    install_packages
    configure_tor
    configure_firewall
    setup_user
    install_memes
    configure_desktop
    configure_plymouth
    cleanup_chroot
    create_iso_structure
    create_squashfs
    generate_iso
    calculate_checksums
    
    echo
    print_success "🎉 Gooner Linux ISO build complete!"
    print_meme "You're now ready to boot like a chad!"
    echo
    echo -e "${CYAN}ISO file: $ISO_NAME${NC}"
    echo -e "${CYAN}Size: $(du -h $ISO_NAME | cut -f1)${NC}"
    echo
    echo "To create a bootable USB:"
    echo "sudo dd if=$ISO_NAME of=/dev/sdX bs=4M status=progress"
    echo
    echo "Or use a GUI tool like Rufus, Etcher, or GNOME Disks"
    echo
    print_meme "Stay anonymous, stay memey! 🐧"
}

# Run main function
main "$@"
