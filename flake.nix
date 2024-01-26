{
  description = "konix flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
  };

  outputs = inputs@{ self, nixpkgs, ...}: {
    
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
    };
  };
}
