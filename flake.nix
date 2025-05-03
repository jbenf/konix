{
  description = "konix flake";
  
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ...}:
  let
    globalModules = [
      /etc/nixos/hardware-configuration.nix
      ./modules
      ({ config, pkgs, ... }: {
        system.configurationRevision = self.rev or self.dirtyRev or null; 
        system.stateVersion = "23.11";
        nix.settings.experimental-features = [ "nix-command" "flakes" ];
        nixpkgs.config.allowUnfree = true;
        programs.command-not-found.enable = false;
        environment.localBinInPath = true;
        hardware.bluetooth.enable = true;

        # Disable the root user
        #users.users.root.hashedPassword = "!";
      })
    ];
    kollektivModules = globalModules ++ [
      ./users/kollektiv
      ./modules/dymo
      ({ config, pkgs, ...}: {
        services.printing.drivers = [ pkgs.gutenprint pkgs.hplip pkgs.cups-dymo ];
      })
    ];
    mariaModules = globalModules ++ [
      ./users/maria
      ({ config, pkgs, ...}: {
        services.printing.drivers = [ pkgs.gutenprint pkgs.foomatic-db-ppds pkgs.canon-cups-ufr2 ];
      })
      home-manager.nixosModules.home-manager
      ({ config, pkgs, lib, ... }: {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.maria = import ./users/maria/home;
      })
    ];
  in {
    
    nixosConfigurations = {
      konix0 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = kollektivModules ++ [
          {
            networking.hostName = "konix0";
          }
        ];
      };
      kobook1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = kollektivModules ++ [
          {
            networking.hostName = "kobook1";
          }
        ];
      };
      kobook2 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = kollektivModules ++ [
          {
            networking.hostName = "kobook2";
          }
        ];
      };
      maria = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        
        modules = mariaModules ++ [
          {
            networking.hostName = "maria";
          }
        ];
      };
    };
  };
}
