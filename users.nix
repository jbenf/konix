# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

    
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kollektiv = {
    isNormalUser = true;
    description = "Kollektiv";
    extraGroups = [ "networkmanager" ];
    packages = with pkgs; [
      chromium
      keepassxc
      libreoffice
      #inkscape
      #gimp
      #vlc
    ];
  };

  # users.users.admin = {
  #   isNormalUser = true;
  #   description = "Admin";
  #   extraGroups = [ "networkmanager" "wheel" "dialout"  ];
  # };

  environment.localBinInPath = true;

  # Disable the root user
  #users.users.root.hashedPassword = "!";

  security.polkit.enable=true;

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("users")
          && action.id == "org.freedesktop.systemd1.manage-units" 
          && (
            action.lookup("unit") == "nix-gc.service" ||
            action.lookup("unit") == "nix-optimise.service" ||
            action.lookup("unit") == "nixos-upgrade.service" ||
            action.lookup("unit") == "konix-flake-update.service" ||
          )
        )
      {
        return polkit.Result.YES;
      }
    })
  '';

  security.sudo.extraRules = [
    { groups = [ "users" ]; runAs = "root"; 
      commands = [ 
        { command = "/usr/bin/systemctl start nix-gc.service"; options = [ "NOPASSWD" ]; }
        { command = "/usr/bin/systemctl start nix-optimise.service"; options = [ "NOPASSWD" ]; }
        { command = "/usr/bin/systemctl start nixos-upgrade.service"; options = [ "NOPASSWD" ]; }
        { command = "/usr/bin/systemctl start konix-flake-update.service"; options = [ "NOPASSWD" ]; }
      ]; 
    }
  ]; 

}

