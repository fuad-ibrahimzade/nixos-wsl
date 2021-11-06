{ nixpkgs ? import <nixpkgs> {} }:

let
  pkgs = import <nixpkgs> {};

  python = pkgs.python38.withPackages (ps : with ps; [
    #pybind11 qcelemental numpy pylibefp
    dbus-next
    dbus-python
    pycairo
    pygobject3
    ps.setproctitle
    ps.xlib
  ]);

  
  myDerivation = pkgs.stdenv.mkDerivation {
    name = "plasma-hud";
    #nativeBuildInputs = [
    #  pkgs.makeWrapper
    #  #pkgs.autoPatchelfHook # Automatically setup the loader, and do the magic
    #  pkgs.wrapGAppsHook
    #];

    buildInputs = [
      pkgs.rofi
  
      pkgs.pkg-config
      pkgs.pkgconfig
      #pkgs.autoreconfHook
      #pkgs.autoconf
      #pkgs.automake
      #pkgs.libtool
      #pkgs.cairo
      #pkgs.gobject-introspection
      pkgs.gtk3
      pkgs.gtk2
      pkgs.dbus-glib
      (pkgs.python38.withPackages (
       ps: [
         ps.dbus-python 
         ps.dbus-next
         ps.pygobject3
         ps.pycairo
         ps.setproctitle
         ps.xlib
       ]
       )
      )
      (pkgs.callPackage "/home/qaqulya/plasma-hud/appmenu-gtk-module3.nix" {})
      
      pkgs.libdbusmenu
      pkgs.libdbusmenu_qt
      pkgs.libdbusmenu-gtk3
      pkgs.libwnck3 pkgs.bamf pkgs.git
      
      pkgs.xorg.libX11
      pkgs.xorg.libX11.dev
      pkgs.bamf pkgs.keybinder3 
      pkgs.wrapGAppsHook
  
   
    ];
    nativeBuildInputs = with pkgs; [
      autoPatchelfHook # Automatically setup the loader, and do the magic
      makeWrapper
      pkg-config
    ];
    src = ./.;
   installPhase = ''
    mkdir -p $out/bin;
    #chmod +x $src/plasma-hud
    cp $src/plasma-hud $out/bin
    chmod +x $out/bin/plasma-hud
   '';
};

  mergedDrv = pkgs.symlinkJoin {
    name ="merged-package";
    paths = [ pkgs.gtk3 myDerivation.out plasma-hud-bin.out ];
  };

  plasma-hud-bin = pkgs.writeShellScriptBin "plasma-hud-bin" ''
    #"${python}/bin/python" "{mergedDrv.out}/bin/plasma-hud";
    #plasma-hud-executable=$(find ${myDerivation.out}/ -type f -regex ".*plasma-hud$")
    plasma-hud-executable=$(find $out/ -type f -regex ".*plasma-hud$")
    "$out/bin/python" "$plasma-hud-executable";
  '';


 
in 
  mergedDrv
  #myDerivation

