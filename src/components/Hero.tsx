import { Button } from "@/components/ui/button";
import { Shield, Zap, Smile, Download } from "lucide-react";
import heroBanner from "@/assets/hero-banner.png";

const Hero = () => {
  return (
    <section className="relative min-h-screen flex items-center justify-center overflow-hidden">
      {/* Background */}
      <div 
        className="absolute inset-0 bg-cover bg-center opacity-30"
        style={{ backgroundImage: `url(${heroBanner})` }}
      />
      <div className="absolute inset-0 bg-gradient-dark" />
      
      {/* Matrix rain effect */}
      <div className="absolute inset-0 opacity-20">
        <div className="matrix-rain text-matrix-green text-xs font-mono leading-3 overflow-hidden h-full">
          {Array.from({ length: 50 }, (_, i) => (
            <div
              key={i}
              className="absolute animate-pulse"
              style={{
                left: `${Math.random() * 100}%`,
                animationDelay: `${Math.random() * 5}s`,
                animationDuration: `${3 + Math.random() * 4}s`
              }}
            >
              {Array.from({ length: 20 }, (_, j) => (
                <div key={j} className="mb-1">
                  {Math.random() > 0.5 ? '1' : '0'}
                </div>
              ))}
            </div>
          ))}
        </div>
      </div>
      
      {/* Content */}
      <div className="relative z-10 text-center max-w-4xl mx-auto px-4">
        <div className="space-y-6">
          <h1 className="text-6xl md:text-8xl font-black text-transparent bg-gradient-glow bg-clip-text leading-tight">
            GOONER
            <br />
            <span className="text-4xl md:text-6xl">LINUX</span>
          </h1>
          
          <p className="text-xl md:text-2xl text-muted-foreground max-w-2xl mx-auto">
            The ultimate privacy-focused meme OS. Route through Tor, stay anonymous, 
            and boot like a <span className="text-neon-green font-bold">chad</span>.
          </p>
          
          <div className="flex flex-wrap gap-4 justify-center items-center text-sm">
            <div className="flex items-center gap-2 bg-card/50 px-3 py-2 rounded-lg">
              <Shield className="w-4 h-4 text-neon-green" />
              <span>Tor by Default</span>
            </div>
            <div className="flex items-center gap-2 bg-card/50 px-3 py-2 rounded-lg">
              <Zap className="w-4 h-4 text-neon-purple" />
              <span>Live USB Ready</span>
            </div>
            <div className="flex items-center gap-2 bg-card/50 px-3 py-2 rounded-lg">
              <Smile className="w-4 h-4 text-accent" />
              <span>100% Memes</span>
            </div>
          </div>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center mt-8">
            <Button size="lg" className="bg-gradient-glow hover:shadow-glow-green text-lg px-8 py-4">
              <Download className="w-5 h-5 mr-2" />
              Download ISO (2.1GB)
            </Button>
            <Button variant="outline" size="lg" className="text-lg px-8 py-4">
              View on GitHub
            </Button>
          </div>
          
          <p className="text-xs text-muted-foreground mt-4">
            Current Version: v1.0.0-chad | Based on Debian 12 | Last Updated: Today
          </p>
        </div>
      </div>
    </section>
  );
};

export default Hero;