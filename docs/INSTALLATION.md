# Gooner Linux Installation Guide

This guide will walk you through building and installing Gooner Linux, the privacy-focused meme OS.

## 🛠️ Building the ISO

### Prerequisites

You'll need a Debian or Ubuntu-based system with:
- At least 8GB free disk space
- 4GB RAM (8GB recommended)
- Internet connection
- Root/sudo access

### Dependencies

The build script will automatically install required packages, but you can install them manually:

```bash
sudo apt update
sudo apt install -y \
    debootstrap \
    squashfs-tools \
    xorriso \
    syslinux-utils \
    isolinux \
    mtools \
    dosfstools
```

### Building Process

1. **Clone the repository:**
```bash
git clone https://github.com/gooner-linux/gooner-linux.git
cd gooner-linux
```

2. **Make the build script executable:**
```bash
chmod +x build_gooner.sh
```

3. **Run the build script:**
```bash
./build_gooner.sh
```

The build process will:
- Bootstrap a Debian base system
- Install privacy and security tools
- Configure Tor networking
- Add meme content and Easter eggs
- Create the bootable ISO

**Build time:** 30-60 minutes depending on your internet speed and hardware.

### Build Options

You can customize the build by editing variables in `build_gooner.sh`:

```bash
# Change base distribution
DEBIAN_SUITE="bookworm"  # or "bullseye", "sid"

# Change architecture  
ARCHITECTURE="amd64"     # or "i386" for 32-bit

# Change mirror for faster downloads
DEBIAN_MIRROR="http://deb.debian.org/debian"
```

### Troubleshooting Build Issues

**Out of disk space:**
```bash
# Clean up previous builds
sudo rm -rf gooner-build/
```

**Network issues:**
```bash
# Use a different mirror
DEBIAN_MIRROR="http://ftp.us.debian.org/debian"
```

**Permission errors:**
```bash
# Ensure you're not running as root
whoami  # Should NOT be root
```

## 📀 Creating Bootable Media

### USB Drive (Recommended)

**Using dd (Linux/macOS):**
```bash
# Find your USB drive
lsblk

# Flash the ISO (replace /dev/sdX with your USB device)
sudo dd if=gooner-linux-v1.0.0-chad.iso of=/dev/sdX bs=4M status=progress

# Sync to ensure all data is written
sync
```

**Using GUI tools:**
- **Linux:** GNOME Disks, KDE ISO Image Writer
- **Windows:** Rufus, Etcher
- **macOS:** Etcher, dd command

**Rufus Settings (Windows):**
- Partition scheme: MBR
- Target system: BIOS or UEFI
- File system: FAT32
- Cluster size: Default

### DVD/CD

Most modern systems don't need optical media, but if required:

```bash
# Burn to DVD
wodim -v dev=/dev/sr0 -speed=4 gooner-linux-v1.0.0-chad.iso

# Or use GUI tools like Brasero, K3b
```

### Virtual Machine

For testing purposes:

**VirtualBox:**
1. Create new VM with 4GB+ RAM
2. Attach ISO as optical drive
3. Boot from CD/DVD

**QEMU:**
```bash
qemu-system-x86_64 -m 4G -cdrom gooner-linux-v1.0.0-chad.iso
```

## 🚀 Booting Gooner Linux

### Boot Options

When you boot from the USB/DVD, you'll see the Gooner Linux boot menu:

1. **"Boot Like a Chad - Gooner Linux Live"** (Default)
   - Standard boot with all features enabled
   - Recommended for most users

2. **"Gooner Mode: Activated (Safe Graphics)"**
   - Uses safe graphics drivers
   - For systems with problematic GPU drivers

3. **"Memory Test"**
   - Tests your system RAM for errors
   - Useful for troubleshooting hardware issues

### BIOS/UEFI Settings

**Enable USB boot:**
1. Enter BIOS/UEFI setup (usually F2, F12, or Del during startup)
2. Enable "USB Boot" or "Legacy USB Support"
3. Set USB drive as first boot device
4. Save and exit

**Secure Boot:**
- Gooner Linux is not signed, so disable Secure Boot if enabled
- Usually found in Security or Boot settings

### First Boot Process

1. **Boot Animation:** Rotating meme images with privacy messages
2. **Hardware Detection:** Automatic driver loading
3. **Network Setup:** Tor configuration and MAC randomization
4. **Desktop Launch:** XFCE desktop environment starts
5. **Welcome Screen:** First-time setup and tour

## 🏠 Live Environment

### User Account

**Default credentials:**
- Username: `gooner`
- Password: `gooner`

**Sudo access:** The gooner user has passwordless sudo access for system administration.

### Network Connection

**Wired connection:** Should work automatically with DHCP

**WiFi setup:**
1. Click network icon in system tray
2. Select your WiFi network
3. Enter password
4. All traffic automatically routes through Tor

### Verifying Tor Connection

**Check Tor status:**
```bash
tor-status                    # Check if Tor is running
tor-check                     # Verify your IP is anonymous
curl https://check.torproject.org
```

**Monitor Tor connections:**
```bash
nyx                          # Interactive Tor monitor
```

### Essential Commands

**System information:**
```bash
chad                         # Show system info (neofetch)
```

**Memes and fun:**
```bash
joke                         # Random meme/joke
shrek                        # Shrek Easter egg
matrix                       # Matrix rain effect
```

**Privacy tools:**
```bash
firewall                     # Check firewall status
new-identity                 # Get new Tor circuit
secure-delete filename       # Securely delete files
```

## 💾 Persistent Storage

By default, Gooner Linux runs entirely in RAM and doesn't save changes. For persistent storage:

### Creating Persistent Partition

1. **Identify your USB drive:**
```bash
lsblk
# Look for your USB drive (usually /dev/sdb)
```

2. **Create encrypted persistent partition:**
```bash
# Create partition (adjust size as needed)
sudo fdisk /dev/sdb
# Create new partition in remaining space

# Encrypt the partition
sudo cryptsetup luksFormat /dev/sdb2
sudo cryptsetup luksOpen /dev/sdb2 persistence

# Format and label
sudo mkfs.ext4 -L persistence /dev/mapper/persistence

# Configure persistence
sudo mount /dev/mapper/persistence /mnt
echo "/ union" | sudo tee /mnt/persistence.conf
sudo umount /dev/mapper/persistence
sudo cryptsetup luksClose persistence
```

3. **Boot with persistence:**
   - Add `persistence` to boot parameters
   - Enter LUKS password when prompted

### What Gets Saved

With persistence enabled:
- User files and configurations
- Installed packages
- Browser bookmarks and settings
- Custom scripts and tools

**Security note:** Persistent storage reduces anonymity. Only enable if you understand the trade-offs.

## 🔧 Customization

### Adding Software

**Temporary (lost on reboot):**
```bash
sudo apt update
sudo apt install package-name
```

**Permanent (requires persistence):**
- Same as above, but with persistent storage enabled

### Custom Scripts

Add your own scripts to `/usr/local/bin/` for system-wide access:

```bash
sudo nano /usr/local/bin/my-script
sudo chmod +x /usr/local/bin/my-script
```

### Desktop Environment

**Change wallpaper:**
- Right-click desktop → Properties → Background

**Customize panel:**
- Right-click panel → Panel → Panel Preferences

**Install themes:**
```bash
sudo apt install numix-gtk-theme arc-theme
```

## 🆘 Troubleshooting

### Boot Issues

**System won't boot:**
- Try "Safe Graphics" mode
- Check USB drive integrity
- Verify ISO checksum

**Kernel panic:**
- Usually hardware compatibility issue
- Try different USB port
- Check RAM with memory test

### Network Issues

**No internet connection:**
```bash
# Check network interfaces
ip addr show

# Restart network manager
sudo systemctl restart NetworkManager

# Check Tor status
systemctl status tor
```

**WiFi not working:**
```bash
# Check for missing firmware
dmesg | grep firmware

# Install firmware package if needed
sudo apt install firmware-iwlwifi  # Intel WiFi
sudo apt install firmware-atheros  # Atheros
```

### Graphics Issues

**Display problems:**
- Boot with "Safe Graphics" option
- Try different video output (HDMI, VGA, etc.)

**Resolution issues:**
```bash
# List available resolutions
xrandr

# Set resolution manually
xrandr --output HDMI-1 --mode 1920x1080
```

### Performance Issues

**Slow performance:**
- Increase RAM allocation in VM
- Close unnecessary applications
- Use lighter applications when possible

**High CPU usage:**
```bash
# Check running processes
htop

# Monitor system resources
top
```

### Privacy Issues

**Tor not working:**
```bash
# Restart Tor service
sudo systemctl restart tor

# Check Tor logs
sudo journalctl -u tor

# Test connection
tor-check
```

**DNS leaks:**
```bash
# Check current DNS servers
cat /etc/resolv.conf

# Should show 127.0.0.1 (local Tor DNS)
```

## 🔐 Security Considerations

### What Gooner Linux Protects Against

✅ **ISP surveillance and tracking**
✅ **Government censorship and monitoring**  
✅ **Corporate data collection**
✅ **Man-in-the-middle attacks**
✅ **DNS hijacking and poisoning**
✅ **Metadata analysis**

### What It Doesn't Protect Against

❌ **Physical access to your device**
❌ **Compromised hardware**
❌ **Advanced persistent threats**
❌ **Social engineering attacks**
❌ **Malicious websites and downloads**
❌ **Your own poor operational security**

### Best Practices

1. **Always verify your Tor connection** before sensitive activities
2. **Use HTTPS websites** whenever possible
3. **Don't download and run** untrusted software
4. **Be aware of JavaScript** and disable if necessary
5. **Use VPN over Tor** for additional protection
6. **Never enter real personal information** while anonymous
7. **Understand your threat model** and limitations

### Advanced Privacy

**VPN over Tor:**
```bash
# Connect to VPN first, then use Tor
sudo openvpn --config your-vpn.ovpn
```

**Tor over VPN:**
```bash
# Use Tor through VPN (default configuration)
# Your ISP sees VPN traffic, VPN sees Tor traffic
```

**Disable JavaScript:**
- In Tor Browser: Security Settings → Safest
- In Firefox: about:config → javascript.enabled → false

## 📚 Additional Resources

### Documentation
- [Tor Project Documentation](https://2019.www.torproject.org/docs/)
- [TAILS Documentation](https://tails.boum.org/doc/)
- [Privacy Guides](https://privacyguides.org/)

### Communities
- r/privacy - Privacy discussions
- r/TOR - Tor network help
- r/linux - General Linux support

### Tools and Extensions
- uBlock Origin - Ad and tracker blocking
- HTTPS Everywhere - Force HTTPS connections
- Privacy Badger - Tracker protection
- NoScript - JavaScript control

---

**Need help?** Join our community channels or open an issue on GitHub!

**Stay safe, stay anonymous, and enjoy the memes!** 🐧