# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  #services.xserver.displayManager.gdm.wayland = false;
  services.xserver.desktopManager.gnome.enable = true;

  # nixpkgs.config.firefox.enableGnomeExtensions = true;

  nixpkgs.config.firefox.nativeMessagingHosts.packages = with pkgs; [
    gnome-browser-connector
  ];
 
  environment.systemPackages = with pkgs; [
    gnomeExtensions.dash-to-dock
    gnome-tweaks
    papirus-icon-theme
    whitesur-gtk-theme
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.gnome.excludePackages = (with pkgs; [
    #gnome-photos
    gnome-tour
    #cheese # webcam tool
    #gnome-music
    #gnome-terminal
    #gedit # text editor
    epiphany # web browser
    #geary # email reader
    #evince # document viewer
    gnome-characters
    #totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    #gnome-calendar
    #gnome-contacts
]);

systemd.user.services.konix-gnome-init = {
    enable = true;
    description = "Gnome Init";

    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig               = {
      Type      = "simple";
      Restart   = "no";
    };

    path = with pkgs; [ glib gnome-shell ];
    script = ''
      set -x
      gsettings set org.gnome.shell disable-user-extensions false
      gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
      gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
      gsettings --schemadir ${pkgs.gnomeExtensions.dash-to-dock}/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas set org.gnome.shell.extensions.dash-to-dock dock-fixed true
      gsettings --schemadir ${pkgs.gnomeExtensions.dash-to-dock}/share/gnome-shell/extensions/dash-to-dock@micxgx.gmail.com/schemas set org.gnome.shell.extensions.dash-to-dock autohide false
      gnome-extensions enable dash-to-dock@micxgx.gmail.com
      favorites="'org.gnome.Nautilus.desktop', 'chromium-browser.desktop', 'org.keepassxc.KeePassXC.desktop', 'startcenter.desktop'"
      if [[ $USER == "kollektiv" ]]; then
        rm $HOME/.local/share/applications/sonos_*.desktop | true
      else
        rm $HOME/.local/share/applications/sonos_*.desktop | true
        favorites="$favorites, 'brave-browser.desktop', 'org.gnome.Software.desktop', 'Zoom.desktop', 'org.gnome.Geary.desktop'"
      fi

      gsettings set org.gnome.shell favorite-apps "[$favorites]"
      
    '';
  };

}
