{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;  
in
pkgs.writeTextFile {
  name = "plasma-i3-xsession";
  destination = "/share/xsessions/plasma-i3.desktop";
  text = ''
    [Desktop Entry]
    Type=XSession
    Exec=${pkgs.coreutils}/bin/env KDEWM=${pkgs.i3-gaps}/bin/i3 ${pkgs.plasma-workspace}/bin/startplasma-x11
    DesktopNames=KDE
    Name=Plasma with i3
    Comment=Plasma with i3
  '';
} // {
  providedSessions = [ "plasma-i3" ];
}
