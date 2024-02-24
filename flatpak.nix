
# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    services.flatpak.enable = true;

    systemd.user.services.konix-flatpak-init = {
        enable = true;
        description = "Flatpak Init";

        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];

        serviceConfig               = {
        Type      = "simple";
        Restart   = "no";
        };

        path = with pkgs; [ flatpak ];
        script = ''
            echo -e "[Desktop Entry]\nName=Sonos Controller\nExec=flatpak run io.github.janbar.noson\nTerminal=false\nType=Application\nIcon=audio-headphones" > $HOME/.local/share/applications/noson.desktopecho -e "[Desktop Entry]\nName=Sonos Controller\nExec=flatpak run io.github.janbar.noson\nTerminal=false\nType=Application\nIcon=audio-headphones" > $HOME/.local/share/applications/noson.desktop
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak update
            flatpak install -y --or-update flathub io.github.janbar.noson
        '';
    };

}

