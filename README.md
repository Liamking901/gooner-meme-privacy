# Gooner Linux 🐧

> **Privacy-focused meme OS designed to run live from a USB stick**

Gooner Linux is a custom Debian-based Linux distribution that routes all internet traffic through Tor by default, includes privacy-hardened tools, and injects humor throughout the user experience. Built for maximum anonymity with maximum memes.

![Gooner Linux](assets/gooner-banner.png)

## 🔥 Features

### 🔐 Privacy & Security
- **Tor by Default**: All internet traffic routed through Tor network
- **Hardened Firewall**: UFW configured with strict default rules  
- **No Telemetry**: Zero data collection or automatic reporting
- **VPN Ready**: Pre-configured OpenVPN and WireGuard clients
- **Encrypted Storage**: Optional persistent storage with LUKS encryption

### 🎭 Meme OS Aesthetic
- **Custom Boot Splash**: Rotating meme images during boot (Plymouth)
- **Meme Prompts**: Custom sudo prompt: "Hey bruv, you sure about that?"
- **ASCII Art**: Terminal startup with custom Gooner Linux branding
- **Easter Eggs**: Run `~/run_shrek.sh` for dancing ASCII Shrek + All Star
- **Custom Sounds**: Meme-themed login and system sounds

### 🛠️ Included Tools

#### Desktop Environment
- **XFCE**: Lightweight, privacy-focused desktop
- **Tor Browser**: Pre-installed and configured
- **Hardened Firefox**: With uBlock Origin, HTTPS Everywhere, Privacy Badger

#### Privacy Tools
- `tor` - The Onion Router
- `torsocks` - Tor wrapper for applications  
- `proxychains4` - Proxy chains for anonymization
- `nyx` - Tor connection monitor
- `macchanger` - MAC address randomization

#### Security Tools  
- `ufw` / `nftables` - Firewall management
- `bleachbit` - Secure file deletion
- `mat2` - Metadata removal tool
- `secure-delete` - Secure file wiping

#### Hacker Tools
- `nmap` - Network mapping and port scanning
- `netcat` - Network swiss army knife
- `wireshark` - Network protocol analyzer  
- `aircrack-ng` - WiFi security auditing
- `hashcat` - Password recovery tool

#### Fun & Meme Tools
- `gooner-joke` - Random meme/dad joke generator
- `cowsay` / Custom replacement - Cursed meme wisdom
- `figlet` / `toilet` - ASCII art text
- `cmatrix` - Matrix-style terminal effect
- `lolcat` - Rainbow text output

## 🚀 Quick Start

### Prerequisites
- Debian/Ubuntu-based system for building
- At least 8GB free disk space
- 4GB+ USB drive for flashing
- Internet connection

### Building the ISO

1. **Clone the repository:**
```bash
git clone https://github.com/gooner-linux/gooner-linux.git
cd gooner-linux
```

2. **Run the build script:**
```bash
chmod +x build_gooner.sh
./build_gooner.sh
```

3. **Flash to USB:**
```bash
# Using dd (replace /dev/sdX with your USB device)
sudo dd if=gooner-linux-v1.0.0-chad.iso of=/dev/sdX bs=4M status=progress

# Or use GUI tools like:
# - Rufus (Windows)
# - Etcher (Cross-platform)  
# - GNOME Disks (Linux)
```

4. **Boot and enjoy!**
   - Boot from USB
   - Select "Boot Like a Chad - Gooner Linux Live"
   - Username: `gooner` / Password: `gooner`

## 📁 Project Structure

```
gooner-linux/
├── build_gooner.sh          # Main ISO builder script
├── config/
│   ├── skel/                # Default user configuration files
│   │   ├── .bashrc         # Custom bash configuration
│   │   ├── .profile        # Shell profile with meme ASCII
│   │   └── .config/        # XFCE and application configs
│   ├── plymouth/           # Boot splash themes
│   │   ├── gooner/        # Custom Plymouth theme
│   │   ├── meme0.png      # Rotating boot images
│   │   ├── meme1.png
│   │   ├── meme2.png
│   │   └── meme3.png
│   ├── wallpapers/         # Meme-themed wallpapers
│   ├── sounds/             # System sounds
│   └── scripts/            # Custom system scripts
├── iso/
│   ├── isolinux/           # BIOS boot configuration
│   ├── boot/grub/          # UEFI boot configuration  
│   └── live/               # Live system files
├── patches/                # System patches and tweaks
├── packages/               # Custom .deb packages
└── docs/                   # Documentation
```

## 🎮 Usage Guide

### First Boot
1. Boot from USB and select boot option
2. System will start with Tor routing automatically enabled
3. Login with `gooner:gooner` credentials
4. Check connection: `curl --socks5 127.0.0.1:9050 https://check.torproject.org`

### Privacy Features

#### Tor Configuration
- **Check Tor status:** `systemctl status tor`
- **Monitor connections:** `nyx`
- **Test anonymity:** Visit https://check.torproject.org

#### Firewall Management
```bash
# Check firewall status
sudo ufw status

# Allow specific application
sudo ufw allow firefox

# Block specific port
sudo ufw deny 22
```

#### VPN Setup
```bash
# OpenVPN
sudo openvpn --config your-config.ovpn

# WireGuard  
sudo wg-quick up your-config.conf
```

### Meme Commands

#### Random Joke
```bash
gooner-joke
# Output: "Why did the privacy advocate cross the road? To avoid being tracked!"
```

#### Shrek Easter Egg
```bash
cd ~
./run_shrek.sh
# Displays dancing ASCII Shrek and plays "All Star"
```

#### Custom ASCII
```bash
# System info with style
neofetch

# Matrix effect
cmatrix

# Rainbow text
echo "Gooner Linux" | lolcat
```

### Persistent Storage

To save data between reboots:

1. **Create encrypted partition:**
```bash
sudo cryptsetup luksFormat /dev/sdX2
sudo cryptsetup luksOpen /dev/sdX2 persistence
sudo mkfs.ext4 -L persistence /dev/mapper/persistence
sudo mount /dev/mapper/persistence /mnt
echo "/ union" | sudo tee /mnt/persistence.conf
sudo umount /dev/mapper/persistence
sudo cryptsetup luksClose persistence
```

2. **Boot with persistence:**
   - Select "Persistent Mode" from boot menu
   - Enter LUKS password when prompted

## 🛡️ Security Notes

### Default Security Posture
- All traffic routed through Tor by default
- Firewall blocks all incoming connections
- No automatic updates or telemetry
- MAC address randomization enabled
- Secure DNS via Tor (port 5353)

### Recommended Practices
1. **Always verify Tor connection** before sensitive activities
2. **Use VPN over Tor** for additional layers (VPN → Tor → Internet)
3. **Enable persistent storage encryption** for saved data
4. **Regularly update the live ISO** for security patches
5. **Never save sensitive data to unencrypted storage**

### Threat Model
Gooner Linux is designed for:
- ✅ **General privacy browsing**
- ✅ **Avoiding ISP surveillance** 
- ✅ **Bypassing content filtering**
- ✅ **Learning security tools**
- ❌ **High-stakes operational security**
- ❌ **Protection against advanced persistent threats**
- ❌ **Replacing dedicated security distributions**

## 🤝 Contributing

We welcome contributions from the community! Here's how to help:

### Development Setup
```bash
# Fork the repository
git clone https://github.com/YOUR-USERNAME/gooner-linux.git
cd gooner-linux

# Create feature branch
git checkout -b feature/awesome-meme

# Make changes and test
./build_gooner.sh

# Submit pull request
```

### Contributing Guidelines
- **Memes encouraged** but keep it tasteful
- **Security first** - all privacy features must be thoroughly tested
- **Document everything** - especially new features
- **Test on real hardware** - VMs don't catch everything
- **Follow Debian standards** for packaging

### Areas Needing Help
- 🎨 **Plymouth themes** and boot animations
- 🔊 **Sound design** for system events  
- 🎭 **Meme content** and Easter eggs
- 🔒 **Security hardening** and privacy tools
- 📚 **Documentation** and tutorials
- 🌐 **Translations** for international memes

## 🐛 Known Issues

- **WiFi drivers**: Some proprietary WiFi chipsets may not work
- **Nvidia graphics**: Use "Safe Graphics" boot option for Nvidia cards  
- **Bluetooth**: Disabled by default for privacy (can be enabled)
- **Microcode**: Intel/AMD microcode updates not included
- **Swap**: No swap partition created (uses zram instead)

## 📜 License

Gooner Linux is released under the **GNU General Public License v3.0**.

- ✅ **Use** for any purpose
- ✅ **Study** and modify the source code  
- ✅ **Distribute** copies and modifications
- ❌ **Distribute without source code**
- ❌ **Use proprietary licenses** for derivatives

See [LICENSE](LICENSE) for full details.

## 🙏 Acknowledgments

Gooner Linux builds upon the excellent work of:

- **Debian Project** - Base operating system
- **Tor Project** - Anonymity network
- **XFCE** - Desktop environment  
- **TAILS Project** - Privacy OS inspiration
- **Kali Linux** - Security tool selection
- **Meme Community** - Endless inspiration

Special thanks to all the privacy advocates, security researchers, and meme lords who make projects like this possible.

## 📞 Support & Community

- **GitHub Issues**: Bug reports and feature requests
- **Discord**: Real-time chat and meme sharing
- **Reddit**: r/GoonerLinux for discussions
- **Matrix**: #gooner-linux:matrix.org for privacy-focused chat

## ⚠️ Disclaimer

Gooner Linux is provided "AS IS" without warranty of any kind. Users are responsible for:

- ✅ **Verifying** the security and integrity of the system
- ✅ **Understanding** their local laws regarding privacy tools
- ✅ **Using responsibly** and ethically
- ❌ **Illegal activities** or malicious use

The developers are not responsible for any misuse of this software.

---

**Built with 💚 by the Gooner Linux community**

*Stay anonymous, stay memey! 🐧*