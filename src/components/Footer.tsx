import { Github, Shield, Zap, Heart } from "lucide-react";
import logo from "@/assets/gooner-logo.png";

const Footer = () => {
  return (
    <footer className="bg-darker-bg border-t border-border py-12">
      <div className="container mx-auto px-4">
        <div className="grid md:grid-cols-4 gap-8 mb-8">
          {/* Brand */}
          <div className="md:col-span-1">
            <div className="flex items-center space-x-3 mb-4">
              <img src={logo} alt="Gooner Linux" className="w-8 h-8" />
              <span className="text-xl font-bold text-neon-green">Gooner Linux</span>
            </div>
            <p className="text-sm text-muted-foreground mb-4">
              Privacy-focused meme OS for the culture. Built by chads, for chads.
            </p>
            <div className="flex space-x-4">
              <a href="#" className="text-muted-foreground hover:text-neon-green transition-colors">
                <Github className="w-5 h-5" />
              </a>
              <a href="#" className="text-muted-foreground hover:text-neon-green transition-colors">
                <Shield className="w-5 h-5" />
              </a>
              <a href="#" className="text-muted-foreground hover:text-neon-green transition-colors">
                <Zap className="w-5 h-5" />
              </a>
            </div>
          </div>
          
          {/* Download */}
          <div>
            <h3 className="font-semibold mb-4">Download</h3>
            <ul className="space-y-2 text-sm text-muted-foreground">
              <li><a href="#" className="hover:text-neon-green transition-colors">Stable Release</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">Beta Release</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">Source Code</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">Build Script</a></li>
            </ul>
          </div>
          
          {/* Documentation */}
          <div>
            <h3 className="font-semibold mb-4">Documentation</h3>
            <ul className="space-y-2 text-sm text-muted-foreground">
              <li><a href="#" className="hover:text-neon-green transition-colors">Installation Guide</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">User Manual</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">Privacy Features</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">Meme Commands</a></li>
            </ul>
          </div>
          
          {/* Community */}
          <div>
            <h3 className="font-semibold mb-4">Community</h3>
            <ul className="space-y-2 text-sm text-muted-foreground">
              <li><a href="#" className="hover:text-neon-green transition-colors">Discord</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">Reddit</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">Matrix Chat</a></li>
              <li><a href="#" className="hover:text-neon-green transition-colors">Contribute</a></li>
            </ul>
          </div>
        </div>
        
        {/* Bottom */}
        <div className="border-t border-border pt-8 flex flex-col md:flex-row justify-between items-center">
          <div className="text-sm text-muted-foreground mb-4 md:mb-0">
            © 2024 Gooner Linux. Made with <Heart className="w-4 h-4 inline text-neon-purple" /> by the community.
          </div>
          <div className="flex space-x-6 text-sm text-muted-foreground">
            <a href="#" className="hover:text-neon-green transition-colors">Privacy Policy</a>
            <a href="#" className="hover:text-neon-green transition-colors">Terms</a>
            <a href="#" className="hover:text-neon-green transition-colors">License</a>
          </div>
        </div>
        
        {/* Easter Egg */}
        <div className="text-center mt-8 text-xs text-muted-foreground">
          <p>
            "Hey bruv, you sure about that?" - sudo prompt, probably
          </p>
        </div>
      </div>
    </footer>
  );
};

export default Footer;