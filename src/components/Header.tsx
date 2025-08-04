import { Button } from "@/components/ui/button";
import { Shield, Download, Code, Users } from "lucide-react";
import logo from "@/assets/gooner-logo.png";

const Header = () => {
  return (
    <header className="border-b border-border bg-card/50 backdrop-blur-sm sticky top-0 z-50">
      <div className="container mx-auto px-4 py-3 flex items-center justify-between">
        <div className="flex items-center space-x-3">
          <img src={logo} alt="Gooner Linux" className="w-10 h-10" />
          <div>
            <h1 className="text-xl font-bold text-neon-green">Gooner Linux</h1>
            <p className="text-xs text-muted-foreground">Privacy-focused meme OS</p>
          </div>
        </div>
        
        <nav className="hidden md:flex items-center space-x-6">
          <a href="#features" className="text-foreground hover:text-neon-green transition-colors">
            Features
          </a>
          <a href="#download" className="text-foreground hover:text-neon-green transition-colors">
            Download
          </a>
          <a href="#docs" className="text-foreground hover:text-neon-green transition-colors">
            Docs
          </a>
          <a href="#community" className="text-foreground hover:text-neon-green transition-colors">
            Community
          </a>
        </nav>
        
        <div className="flex items-center space-x-2">
          <Button variant="outline" size="sm" className="hidden md:inline-flex">
            <Code className="w-4 h-4 mr-2" />
            GitHub
          </Button>
          <Button size="sm" className="bg-gradient-glow hover:shadow-glow-green">
            <Download className="w-4 h-4 mr-2" />
            Download
          </Button>
        </div>
      </div>
    </header>
  );
};

export default Header;