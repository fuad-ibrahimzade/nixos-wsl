{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;  
  archPackageDrv =  pkgs.stdenv.mkDerivation {
    name = "archPackage1";
    src = ./vala-panel-appmenu-xfce-git-0.7.6.r7.g46c2fbb-1-x86_64.pkg.tar.zst;
  
    # Required for compilation
    nativeBuildInputs = with pkgs; [
      autoPatchelfHook # Automatically setup the loader, and do the magic
      dpkg
      zstd
      gnutar
      makeWrapper
    ];
  
    # Required at running time
    buildInputs = with pkgs; [
      glibc
      gcc-unwrapped
      bamf
      xorg.libX11
      gtk3
      gtk2
      xfce.xfce4-panel
      xfce.xfconf
    ];
  
    unpackPhase = "true";
  
    # Extract and copy executable in $out/bin
    installPhase = ''
      mkdir -p $out
      #dpkg -x $src $out/tmp-extract
      #zstd -d "$src" --output-dir-flat $out/tmp-extract
      tar -I zstd -xvf $src -C $out
    '';
  };
  mergedDrv = pkgs.symlinkJoin {
    name ="merged-package";
    paths = [ pkgs.xfce.xfce4-panel archPackageDrv.out ];
  };

in
  pkgs.stdenv.mkDerivation {
    name = "appmenu-gtk-module";
    src = ./.;
    installPhase = ''
       #cp -av ${archPackageDrv}/usr/. $out/
       cp -av ${mergedDrv}/usr/. $out/
    '';
     # make sure original package is installed before deriving it!
     buildInputs = [ 
       archPackageDrv
       mergedDrv
     ];
  }
