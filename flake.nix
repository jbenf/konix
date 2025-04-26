{
  description = "konix flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  outputs = inputs@{ self, nixpkgs, ...}:
  let 
    globalModules = [
      ./modules
      ./users.nix
      ./printing.nix
      ({ config, pkgs, ... }: {
        system.configurationRevision = self.rev or self.dirtyRev or null; 
        system.stateVersion = "23.11";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.config.allowUnfree = true;
        programs.command-not-found.enable = false;
        services.printing.enable = true;
      })
    ];
  in {
    
    nixosConfigurations = {
      konix0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = globalModules ++ [
            networking.hostName = "konix0";
        ];
      };
      kobook1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = globalModules ++ [
            networking.hostName = "kobook1";
        ];
      };
      kobook2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = globalModules ++ [
            networking.hostName = "kobook2";
        ];
      };
    };
  };
}
