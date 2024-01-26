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

  /*security.polkit.enable=true;

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
  '';*/

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
    konix-update = "sudo systemctl start nix-gc && sleep 1 && sudo systemctl start nix-optimise && sleep 1 && sudo systemctl start konix-flake-update && sleep 1 && sudo systemctl start nixos-upgrade && sleep 1 && systemctl --user start konix-reboot-check && echo Update completed";
  };

}

