{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;  
  debPackageDrv =  pkgs.stdenv.mkDerivation {
    name = "debPackage1";
    src = ./appmenu-registrar_0.7.6-2_amd64.deb;
  
    # Required for compilation
    nativeBuildInputs = with pkgs; [
      autoPatchelfHook # Automatically setup the loader, and do the magic
      dpkg
    ];
  
    # Required at running time
    buildInputs = with pkgs; [
      glibc
      gcc-unwrapped
      bamf
    ];
  
    unpackPhase = "true";
  
    # Extract and copy executable in $out/bin
    installPhase = ''
      mkdir -p $out/{libexec,share}
      dpkg -x $src $out/tmp-extract
      cp -av $out/tmp-extract/usr/libexec/. $out/libexec
      cp -av $out/tmp-extract/usr/share/. $out/share
      rm -rf $out/tmp-extract
    '';
  };
in
  pkgs.stdenv.mkDerivation {
    name = "appmenu-registrar";
    #builder = pkgs.writeText "builder.sh" ''
      ## source standard environment
      #. $stdenv/setup
#
      ## shorthands
      #refpkg=${pkgs.xfce.xfce4-panel}
#
      ## create output dirs for new derivation
      ##mkdir -p $out/{bin,lib,share}
#
      ## link unchanged files from the original package 
      #ln -sf $refpkg $out
      ##ln -sf $refpkg/bin $out
      ##ln -sf $refpkg/libexec $out
      ##find $refpkg/share -maxdepth 1 \
      ##  -not -name gnome-session -exec ln -sf {} $out/share \;
#
      ## make changes
      ##mkdir -p $out/tmp-extract
      ##cp -av ${debPackageDrv}/. $out/tmp-extract
    #'';
    src = ./.;
    installPhase = ''
       cp -av ${debPackageDrv}/. $out/
    '';
     # make sure original package is installed before deriving it!
     buildInputs = [ 
       debPackageDrv
     ];
  }
