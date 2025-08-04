import { Button } from "@/components/ui/button";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { Download as DownloadIcon, Github, FileText, Shield, Zap } from "lucide-react";

const Download = () => {
  return (
    <section id="download" className="py-20 bg-background">
      <div className="container mx-auto px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-bold text-transparent bg-gradient-glow bg-clip-text mb-4">
            Get Gooner Linux
          </h2>
          <p className="text-xl text-muted-foreground max-w-3xl mx-auto">
            Download the ISO, flash to USB, and boot like a chad. It's that easy.
          </p>
        </div>
        
        <div className="grid md:grid-cols-2 gap-8 mb-12">
          {/* Main Download */}
          <Card className="bg-gradient-glow p-1">
            <div className="bg-background rounded-lg h-full">
              <CardHeader>
                <div className="flex items-center justify-between">
                  <CardTitle className="text-2xl flex items-center gap-2">
                    <Zap className="w-6 h-6 text-neon-green" />
                    Stable Release
                  </CardTitle>
                  <Badge className="bg-neon-green text-black">Recommended</Badge>
                </div>
                <p className="text-muted-foreground">
                  Production-ready build with all features working smoothly.
                </p>
              </CardHeader>
              <CardContent className="space-y-4">
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <span className="font-semibold">Version:</span>
                    <p className="text-muted-foreground">v1.0.0-chad</p>
                  </div>
                  <div>
                    <span className="font-semibold">Size:</span>
                    <p className="text-muted-foreground">2.1 GB</p>
                  </div>
                  <div>
                    <span className="font-semibold">Base:</span>
                    <p className="text-muted-foreground">Debian 12</p>
                  </div>
                  <div>
                    <span className="font-semibold">Desktop:</span>
                    <p className="text-muted-foreground">XFCE</p>
                  </div>
                </div>
                
                <div className="space-y-2">
                  <Button className="w-full bg-gradient-glow hover:shadow-glow-green" size="lg">
                    <DownloadIcon className="w-5 h-5 mr-2" />
                    Download gooner-linux-v1.0.0.iso
                  </Button>
                  <p className="text-xs text-center text-muted-foreground">
                    SHA256: a1b2c3d4e5f6...
                  </p>
                </div>
              </CardContent>
            </div>
          </Card>
          
          {/* Beta Download */}
          <Card className="bg-card/50 border-border">
            <CardHeader>
              <div className="flex items-center justify-between">
                <CardTitle className="text-2xl flex items-center gap-2">
                  <Shield className="w-6 h-6 text-neon-purple" />
                  Beta Release
                </CardTitle>
                <Badge variant="outline" className="border-neon-purple">Beta</Badge>
              </div>
              <p className="text-muted-foreground">
                Latest features and improvements. For brave chads only.
              </p>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4 text-sm">
                <div>
                  <span className="font-semibold">Version:</span>
                  <p className="text-muted-foreground">v1.1.0-beta</p>
                </div>
                <div>
                  <span className="font-semibold">Size:</span>
                  <p className="text-muted-foreground">2.3 GB</p>
                </div>
                <div>
                  <span className="font-semibold">Base:</span>
                  <p className="text-muted-foreground">Debian 12</p>
                </div>
                <div>
                  <span className="font-semibold">Desktop:</span>
                  <p className="text-muted-foreground">XFCE</p>
                </div>
              </div>
              
              <div className="space-y-2">
                <Button variant="outline" className="w-full" size="lg">
                  <DownloadIcon className="w-5 h-5 mr-2" />
                  Download Beta ISO
                </Button>
                <p className="text-xs text-center text-muted-foreground">
                  May contain bugs. You've been warned.
                </p>
              </div>
            </CardContent>
          </Card>
        </div>
        
        {/* Additional Resources */}
        <div className="grid md:grid-cols-3 gap-6">
          <Card className="bg-card/50 border-border text-center">
            <CardContent className="pt-6">
              <Github className="w-12 h-12 text-neon-green mx-auto mb-4" />
              <h3 className="text-xl font-semibold mb-2">Source Code</h3>
              <p className="text-muted-foreground mb-4 text-sm">
                Build it yourself or contribute to the project.
              </p>
              <Button variant="outline" className="w-full">
                View on GitHub
              </Button>
            </CardContent>
          </Card>
          
          <Card className="bg-card/50 border-border text-center">
            <CardContent className="pt-6">
              <FileText className="w-12 h-12 text-neon-purple mx-auto mb-4" />
              <h3 className="text-xl font-semibold mb-2">Documentation</h3>
              <p className="text-muted-foreground mb-4 text-sm">
                Installation guide and user manual.
              </p>
              <Button variant="outline" className="w-full">
                Read Docs
              </Button>
            </CardContent>
          </Card>
          
          <Card className="bg-card/50 border-border text-center">
            <CardContent className="pt-6">
              <Shield className="w-12 h-12 text-accent mx-auto mb-4" />
              <h3 className="text-xl font-semibold mb-2">Build Script</h3>
              <p className="text-muted-foreground mb-4 text-sm">
                Automated build script for creating your own ISO.
              </p>
              <Button variant="outline" className="w-full">
                Get build_gooner.sh
              </Button>
            </CardContent>
          </Card>
        </div>
        
        {/* Installation Steps */}
        <div className="mt-16 bg-card/30 p-8 rounded-lg border border-border">
          <h3 className="text-2xl font-bold mb-6 text-center">Quick Installation</h3>
          <div className="grid md:grid-cols-3 gap-8">
            <div className="text-center">
              <div className="w-12 h-12 bg-neon-green text-black rounded-full flex items-center justify-center text-xl font-bold mx-auto mb-4">
                1
              </div>
              <h4 className="font-semibold mb-2">Download ISO</h4>
              <p className="text-sm text-muted-foreground">
                Download the Gooner Linux ISO file from above.
              </p>
            </div>
            <div className="text-center">
              <div className="w-12 h-12 bg-neon-purple text-black rounded-full flex items-center justify-center text-xl font-bold mx-auto mb-4">
                2
              </div>
              <h4 className="font-semibold mb-2">Flash to USB</h4>
              <p className="text-sm text-muted-foreground">
                Use Rufus, Etcher, or dd to flash the ISO to a USB drive.
              </p>
            </div>
            <div className="text-center">
              <div className="w-12 h-12 bg-accent text-black rounded-full flex items-center justify-center text-xl font-bold mx-auto mb-4">
                3
              </div>
              <h4 className="font-semibold mb-2">Boot Like a Chad</h4>
              <p className="text-sm text-muted-foreground">
                Boot from USB and enjoy maximum privacy and memes.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};

export default Download;