{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;  
  debPackageDrv =  pkgs.stdenv.mkDerivation {
    name = "debPackage1";
    src = ./appmenu-gtk-module-common_0.7.6-2_all.deb;
  
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
      mkdir -p $out/{lib,share}
      dpkg -x $src $out/tmp-extract
    '';
  };
in
  pkgs.stdenv.mkDerivation {
    name = "appmenu-gtk-module";
    src = ./.;
    installPhase = ''
       cp -av ${debPackageDrv}/tmp-extract/usr/. $out/
    '';
     # make sure original package is installed before deriving it!
     buildInputs = [ 
       debPackageDrv
     ];
  }
