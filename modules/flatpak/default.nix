
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
            flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            flatpak update
            flatpak uninstall -y io.github.janbar.noson | true
        '';
    };

}

