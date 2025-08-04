#d meme OS based on Debian 12
# Author: Gooner Linux Team
# Version: 1.0.0-chad

set -e  # Exit on any error

# Colors for output!/bin/bash

# Gooner Linux ISO Builder Script
# Privacy-focuse
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
    if [[ $EUID -eq 0 ]]; then
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

# Setup build environment
setup_build_env() {
    print_status "Setting up build environment..."
    
    if [[ -d "$WORK_DIR" ]]; then
        print_warning "Build directory exists. Cleaning up..."
        sudo rm -rf "$WORK_DIR"
    fi
    
    mkdir -p "$WORK_DIR"/{chroot,iso/{live,boot/grub},tmp}
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

# Configure chroot environment
configure_chroot() {
    print_status "Configuring chroot environment..."
    
    # Copy resolv.conf for internet access
    sudo cp /etc/resolv.conf "$WORK_DIR/chroot/etc/"
    
    # Mount necessary filesystems
    sudo mount --bind /dev "$WORK_DIR/chroot/dev"
    sudo mount --bind /proc "$WORK_DIR/chroot/proc"
    sudo mount --bind /sys "$WORK_DIR/chroot/sys"
    
    # Configure APT sources
    cat << EOF | sudo tee "$WORK_DIR/chroot/etc/apt/sources.list"
deb $DEBIAN_MIRROR $DEBIAN_SUITE main contrib non-free
deb-src $DEBIAN_MIRROR $DEBIAN_SUITE main contrib non-free
deb $DEBIAN_MIRROR $DEBIAN_SUITE-security main contrib non-free
deb-src $DEBIAN_MIRROR $DEBIAN_SUITE-security main contrib non-free
deb $DEBIAN_MIRROR $DEBIAN_SUITE-updates main contrib non-free
deb-src $DEBIAN_MIRROR $DEBIAN_SUITE-updates main contrib non-free
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
    )
    
    # Privacy and security packages  
    local privacy_packages=(
        "tor" "torsocks" "proxychains4" "nyx"
        "ufw" "nftables" "macchanger" "bleachbit"
        "secure-delete" "mat2" "metadata-cleaner"
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
    
    sudo chroot "$WORK_DIR/chroot" /bin/bash -c "
        export DEBIAN_FRONTEND=noninteractive
        apt update
        apt install -y ${all_packages[*]}
        apt clean
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
    
    # Gooner joke script
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
    
    # Custom sudo prompt
    echo 'Defaults passprompt="Hey bruv, you sure about that? [sudo] password for %p: "' | sudo tee -a "$WORK_DIR/chroot/etc/sudoers"
    
    print_success "Memes installed!"
}

# Configure XFCE and desktop environment
configure_desktop() {
    print_status "Configuring XFCE desktop..."
    
    # Create desktop configuration
    sudo mkdir -p "$WORK_DIR/chroot/etc/skel/.config/xfce4"
    sudo mkdir -p "$WORK_DIR/chroot/home/gooner/.config/xfce4"
    
    # Set dark theme and custom wallpaper
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/skel/.config/xfce4/xfconf/xfce-perchannel-xml/xfce4-desktop.xml"
<?xml version="1.0" encoding="UTF-8"?>
<channel name="xfce4-desktop" version="1.0">
  <property name="desktop-colors" type="array">
    <value type="int">2</value>
    <value type="int">2</value>
    <value type="uint">4278190080</value>
    <value type="uint">4278190080</value>
  </property>
  <property name="last-image" type="string">/usr/share/pixmaps/gooner-wallpaper.jpg</property>
</channel>
EOF
    
    # Configure LightDM for auto-login
    cat << 'EOF' | sudo tee "$WORK_DIR/chroot/etc/lightdm/lightdm.conf"
[Seat:*]
autologin-user=gooner
autologin-user-timeout=0
user-session=xfce
EOF
    
    print_success "Desktop configured!"
}

# Configure Plymouth boot splash
configure_plymouth() {
    print_status "Setting up meme boot splash..."
    
    sudo chroot "$WORK_DIR/chroot" apt install -y plymouth plymouth-themes
    
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

# Gooner Linux logo animation
for (i = 0; i < 4; i++) {
    meme_image[i] = Image("meme" + i + ".png");
    meme_sprite[i] = Sprite(meme_image[i]);
    meme_sprite[i].SetPosition(Window.GetX() + Window.GetWidth() / 2 - meme_image[i].GetWidth() / 2, 
                               Window.GetY() + Window.GetHeight() / 2 - meme_image[i].GetHeight() / 2, i);
}

progress = 0;
fun refresh_callback () {
    progress++;
    meme_sprite[progress % 4].SetOpacity(1);
    meme_sprite[(progress + 3) % 4].SetOpacity(0);
}
Plymouth.SetRefreshFunction (refresh_callback);
EOF
    
    print_success "Plymouth configured!"
}

# Create ISO structure
create_iso_structure() {
    print_status "Creating ISO structure..."
    
    # Copy kernel and initrd
    sudo cp "$WORK_DIR/chroot/boot/vmlinuz-"* "$WORK_DIR/iso/live/vmlinuz"
    sudo cp "$WORK_DIR/chroot/boot/initrd.img-"* "$WORK_DIR/iso/live/initrd"
    
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

# Clean up chroot
cleanup_chroot() {
    print_status "Cleaning up chroot environment..."
    
    sudo chroot "$WORK_DIR/chroot" /bin/bash -c "
        apt autoremove -y
        apt autoclean
        rm -rf /tmp/*
        rm -rf /var/tmp/*
        rm -rf /var/log/*
        history -c
    "
    
    # Unmount bind mounts
    sudo umount "$WORK_DIR/chroot/dev" || true
    sudo umount "$WORK_DIR/chroot/proc" || true  
    sudo umount "$WORK_DIR/chroot/sys" || true
    
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
    
    # Generate the ISO
    sudo xorriso -as mkisofs \
        -iso-level 3 \
        -full-iso9660-filenames \
        -volid "GOONER_LINUX" \
        -eltorito-boot isolinux/isolinux.bin \
        -eltorito-catalog isolinux/boot.cat \
        -no-emul-boot \
        -boot-load-size 4 \
        -boot-info-table \
        -eltorito-alt-boot \
        -e boot/grub/efi.img \
        -no-emul-boot \
        -append_partition 2 0xef "$WORK_DIR/iso/boot/grub/efi.img" \
        -output "$ISO_NAME" \
        -graft-points \
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