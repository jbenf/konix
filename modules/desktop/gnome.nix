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
    soco-cli
  ];

  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    #cheese # webcam tool
    gnome-music
    #gnome-terminal
    #gedit # text editor
    epiphany # web browser
    geary # email reader
    #evince # document viewer
    gnome-characters
    #totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    gnome-calendar
    gnome-contacts
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
      gsettings set org.gnome.shell disable-user-extensions false
      gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
      gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark"
      gnome-extensions enable dash-to-dock@micxgx.gmail.com
      echo -e "[Desktop Entry]\nName=Sonos Play\nExec=sonos _all_ play_uri https://streaming.shoutcast.com/crooze-mp3\nTerminal=false\nType=Application\nIcon=media-playback-start" > $HOME/.local/share/applications/sonos_play.desktop
      echo -e "[Desktop Entry]\nName=Sonos Pause\nExec=sonos _all_ pause\nTerminal=false\nType=Application\nIcon=media-playback-pause" > $HOME/.local/share/applications/sonos_pause.desktop
      echo -e "[Desktop Entry]\nName=Sonos Volume Up\nExec=sonos _all_ relative_volume 5\nTerminal=false\nType=Application\nIcon=audio-volume-high" > $HOME/.local/share/applications/sonos_vol_up.desktop
      echo -e "[Desktop Entry]\nName=Sonos Volume Down\nExec=sonos _all_ relative_volume -5\nTerminal=false\nType=Application\nIcon=audio-volume-low" > $HOME/.local/share/applications/sonos_vol_down.desktop
      gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop', 'chromium-browser.desktop', 'org.keepassxc.KeePassXC.desktop', 'startcenter.desktop', 'io.github.janbar.noson.desktop', 'sonos_play.desktop', 'sonos_pause.desktop', 'sonos_vol_down.desktop', 'sonos_vol_up.desktop']"
    '';
  };

  environment.shellAliases = {
    sonos-crooze = "sonos _all_ play_uri https://streaming.shoutcast.com/crooze-mp3";
    sonos-smartradio = "sonos _all_ play_uri https://stream.sound-team.de/smartradio.mp3";
  };

}
