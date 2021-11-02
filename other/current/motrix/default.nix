{ nixpkgs ? import <nixpkgs> {} }:
let 
  inherit (nixpkgs) pkgs;  
  motrixAppImageDrv = pkgs.stdenv.mkDerivation rec {
    name = "motrix-drv";
  
    src = ./.;
 
    buildInputs = with pkgs; [
      appimage-run
    ];
    appimage = /etc/nixos/motrix/Motrix-1.6.11.AppImage;
    installPhase = ''
      mkdir -p $out/var/lib
      cp ${appimage} $out/var/lib/.
    '';
 
  };

  motrix = pkgs.writeShellScriptBin "motrix" ''
    motrixAppImage=$(find ${motrixAppImageDrv.out}/ -type f -regex ".*Motrix.*")
    "${pkgs.appimage-run}/bin/appimage-run" "$motrixAppImage";
  '';

in
  motrix
