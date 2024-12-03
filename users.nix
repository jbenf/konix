# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

    
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kollektiv = {
    isNormalUser = true;
    description = "Kollektiv";
    extraGroups = [ "networkmanager" "dialout" "tty" ];
    packages = with pkgs; [
      chromium
      keepassxc
      libreoffice
      evince
      #inkscape
      #gimp
      #vlc
    ];
  };

  environment.localBinInPath = true;

  # Disable the root user
  #users.users.root.hashedPassword = "!";


  security.sudo.extraRules = [
    { groups = [ "users" ]; runAs = "root"; 
      commands = [ 
        { command = "/run/current-system/sw/bin/systemctl start nix-gc"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl start nix-optimise"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl start nixos-upgrade"; options = [ "NOPASSWD" ]; }
        { command = "/run/current-system/sw/bin/systemctl start konix-flake-update"; options = [ "NOPASSWD" ]; }
      ]; 
    }
  ];

  environment.shellAliases = {
    konix-update = "sudo systemctl start nix-gc && sleep 1 && sudo systemctl start nix-optimise && sleep 1 && sleep 1 && sudo systemctl start nixos-upgrade && sleep 1 && systemctl --user start konix-gnome-init && systemctl --user start konix-reboot-check && echo Update completed";
  };

}

