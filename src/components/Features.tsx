import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { 
  Shield, 
  Zap, 
  Smile, 
  Eye, 
  Lock, 
  Wifi, 
  Terminal, 
  Music,
  Gamepad2
} from "lucide-react";

const Features = () => {
  const features = [
    {
      icon: <Shield className="w-8 h-8 text-neon-green" />,
      title: "Privacy & Security",
      description: "All traffic routed through Tor by default. No telemetry, no tracking, no BS.",
      items: ["Tor networking", "Hardened firewall", "No telemetry", "VPN ready"]
    },
    {
      icon: <Smile className="w-8 h-8 text-neon-purple" />,
      title: "Meme OS Aesthetic",
      description: "Boot screens, sounds, and prompts that'll make you LOL while staying secure.",
      items: ["Meme boot splash", "Custom ASCII art", "Chad prompts", "Dancing Shrek easter egg"]
    },
    {
      icon: <Zap className="w-8 h-8 text-accent" />,
      title: "Live USB Ready",
      description: "Boot from USB, leave no traces. Perfect for maximum privacy and portability.",
      items: ["Persistent storage", "Zero installation", "Hardware detection", "RAM-based OS"]
    },
    {
      icon: <Eye className="w-8 h-8 text-neon-green" />,
      title: "Anonymity Tools",
      description: "Pre-configured tools for staying invisible online. Browse like a ghost.",
      items: ["Tor Browser", "Hardened Firefox", "VPN clients", "Anonymous DNS"]
    },
    {
      icon: <Terminal className="w-8 h-8 text-matrix-green" />,
      title: "Hacker Tools",
      description: "Everything you need for privacy research and network analysis.",
      items: ["nmap", "curl", "htop", "neofetch", "torify", "Custom scripts"]
    },
    {
      icon: <Gamepad2 className="w-8 h-8 text-neon-purple" />,
      title: "Fun Extras",
      description: "Because privacy doesn't have to be boring. Memes included.",
      items: ["gooner-joke CLI", "Cowsay replacement", "Meme wallpapers", "Rickroll mode"]
    }
  ];

  return (
    <section id="features" className="py-20 bg-gradient-dark">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold text-transparent bg-gradient-glow bg-clip-text mb-4">
            Features That Slap
          </h2>
          <p className="text-xl text-muted-foreground max-w-3xl mx-auto">
            Gooner Linux comes packed with everything you need for maximum privacy, 
            maximum memes, and minimum effort.
          </p>
        </div>
        
        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-6 mb-16">
          {features.map((feature, index) => (
            <Card key={index} className="bg-card/50 border-border hover:border-neon-green/50 transition-all duration-300 hover:shadow-glow-green/20">
              <CardHeader>
                <div className="flex items-center gap-3 mb-2">
                  {feature.icon}
                  <CardTitle className="text-xl">{feature.title}</CardTitle>
                </div>
                <p className="text-muted-foreground">{feature.description}</p>
              </CardHeader>
              <CardContent>
                <div className="flex flex-wrap gap-2">
                  {feature.items.map((item, itemIndex) => (
                    <Badge key={itemIndex} variant="secondary" className="text-xs">
                      {item}
                    </Badge>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
        
        <div className="text-center">
          <div className="inline-block bg-card/50 p-6 rounded-lg border border-border">
            <h3 className="text-2xl font-bold mb-4 text-neon-green">System Requirements</h3>
            <div className="grid md:grid-cols-2 gap-6 text-left">
              <div>
                <h4 className="font-semibold mb-2">Minimum:</h4>
                <ul className="text-sm text-muted-foreground space-y-1">
                  <li>• 2GB RAM</li>
                  <li>• 8GB USB drive</li>
                  <li>• x86_64 processor</li>
                  <li>• 1GB free space</li>
                </ul>
              </div>
              <div>
                <h4 className="font-semibold mb-2">Recommended:</h4>
                <ul className="text-sm text-muted-foreground space-y-1">
                  <li>• 4GB+ RAM</li>
                  <li>• 16GB+ USB drive</li>
                  <li>• Multi-core processor</li>
                  <li>• WiFi capability</li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Features;