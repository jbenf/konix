{
  description = "konix flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ...}: {
    
    nixosConfigurations = {
      konix0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = [
            ./default.nix
            ./konix0.nix
        ];
      };
      kobook1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = [
            ./default.nix
            ./kobook1.nix
            ./notebook.nix
        ];
      };
      kobook2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = [
            ./default.nix
            ./kobook2.nix
            ./notebook.nix
        ];
      };
    };

    homeConfigurations = {
      "kollektiv" = inputs.home-manager.lib.homeManagerConfiguration {
        system = "x86_64-linux";
        homeDirectory = "/home/kollektiv";
        username = "kollektiv";
        configuration.imports = [ ./home.nix ];
      };
    };
  };
}
