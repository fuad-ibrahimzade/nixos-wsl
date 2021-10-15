{ nixpkgs ? import <nixpkgs> {} }:
let
  inherit (nixpkgs) pkgs;  
  #src = "./xfce-appmenu-plugin.deb";
  debPackageDrv =  pkgs.stdenv.mkDerivation {
    name = "new-xfce4-panel";
  
    #system = "x86_64-linux";
  
    #inherit src;
    #src = /home/qaqulya/vala-appmenu/vala2/xfce4-panel-with-appmenu/xfce-appmenu-plugin.deb;
    #src = /home/qaqulya/vala-appmenu/vala2/xfce-appmenu-plugin.deb;
    #src = /home/qaqulya/vala-appmenu/vala2/test.deb;
    src = ./xfce-appmenu-plugin.deb;
  
    # Required for compilation
    nativeBuildInputs = with pkgs; [
      autoPatchelfHook # Automatically setup the loader, and do the magic
      dpkg
    ];
  
    # Required at running time
    buildInputs = with pkgs; [
      glibc
      gcc-unwrapped
      #xfce
      xfce.xfce4-panel
      xfce.xfconf
      bamf
    ];
  
    unpackPhase = "true";
  
    # Extract and copy executable in $out/bin
    installPhase = ''
      mkdir -p $out
      dpkg -x $src $out/tmp-extract
      mkdir -p $out/{bin,lib,share}
      cp -av $out/tmp-extract/usr/lib/x86_64-linux-gnu/* $out/lib
      #cp -av $out/usr/lib/x86_64-linux-gnu/* $out/lib
      cp -av $out/tmp-extract/usr/bin/* $out/bin
      cp -av $out/tmp-extract/usr/share/* $out/share
      #cp -av $out/opt/* $out
      #cp -av $out/opt/test/* $out
      #rm -rf $out/opt
      rm -rf $out/tmp-extract
    '';
  };
  mergedDrv = pkgs.symlinkJoin {
    name ="merged-package";
    paths = [ pkgs.xfce.xfce4-panel debPackageDrv.out ];
  };
in
  pkgs.stdenv.mkDerivation {
    name = "new-xfce4-panel";
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
       #mkdir -p $out/tmp-extract
       #mkdir -p $out/debPackageDrv/{bin,lib,share}
       cp -av ${mergedDrv}/. $out/
       ##cp -av ${debPackageDrv}/. $out/
       #cp -av ${debPackageDrv}/* $out/debPackageDrv
       ##cp -av ${debPackageDrv}/bin/* $out/bin
       ##cp -av ${debPackageDrv}/lib/* $out/lib
       ##cp -av ${debPackageDrv}/share/* $out/share
 #
       #
       #refpkg=${pkgs.xfce.xfce4-panel}
       #mkdir -p $out/refpkg
       #ln -sf $refpkg/* $out/refpkg
#
       #for item in $(diff -ur $out/debPackageDrv $out/refpkg | grep refpkg | awk '{ print $3"/"$4}' | awk -F: '{ print $1""$2 }'); do ln -sf $item $out/debPackageDrv; done;
#
       ##cp -av ${debPackageDrv}/. $out/tmp-extract
    '';
     # make sure original package is installed before deriving it!
     buildInputs = [ 
       pkgs.xfce.xfce4-panel 
       debPackageDrv
       #(pkgs.callPackage debPackageDrv {})
     ];
  }
